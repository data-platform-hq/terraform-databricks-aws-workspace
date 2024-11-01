################################################################################
# Databricks Workspace
################################################################################
resource "databricks_mws_workspaces" "this" {
  account_id                 = var.account_id
  aws_region                 = var.region
  workspace_name             = var.label
  credentials_id             = databricks_mws_credentials.this.credentials_id
  storage_configuration_id   = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id                 = databricks_mws_networks.this.network_id
  private_access_settings_id = try(databricks_mws_private_access_settings.this[0].private_access_settings_id, null)

  dynamic "token" {
    for_each = var.workspace_creator_token_enabled ? [1] : []
    content {
      comment = "Workspace creator token managed by Terraform"
    }
  }

  lifecycle {
    replace_triggered_by = [databricks_mws_credentials.this]
  }

}

resource "databricks_mws_private_access_settings" "this" {
  count = var.private_access_settings_enabled ? 1 : 0

  private_access_settings_name = coalesce(var.private_access_settings_config.name, var.label)
  region                       = var.region
  public_access_enabled        = var.private_access_settings_config.public_access_enabled
  allowed_vpc_endpoint_ids     = coalesce(var.private_access_settings_config.allowed_vpc_endpoint_ids, [var.privatelink_rest_vpce_id])
  private_access_level         = "ENDPOINT"
}

################################################################################
# Network
################################################################################
resource "databricks_mws_networks" "this" {
  account_id         = var.account_id
  network_name       = var.label
  security_group_ids = var.security_group_ids
  subnet_ids         = var.subnet_ids
  vpc_id             = var.vpc_id

  dynamic "vpc_endpoints" {
    for_each = var.privatelink_enabled ? [1] : []
    content {
      dataplane_relay = [coalesce(try(module.privatelink_vpce.relay_vpce_id, null), var.privatelink_relay_vpce_id)]
      rest_api        = [coalesce(try(module.privatelink_vpce.rest_vpce_id, null), var.privatelink_rest_vpce_id)]
    }
  }
}

################################################################################
# Privatelink dedicated VPC Endpoints (REST/Relay)
################################################################################
module "privatelink_vpce" {
  count  = var.privatelink_dedicated_vpce_enabled ? 1 : 0
  source = "./modules/privatelink/"

  account_id                = var.account_id
  region                    = var.region
  relay_vpc_endpoint_name   = var.privatelink_dedicated_vpce_config.relay_vpc_endpoint_name
  relay_aws_vpc_endpoint_id = var.privatelink_dedicated_vpce_config.relay_aws_vpc_endpoint_id
  rest_vpc_endpoint_name    = var.privatelink_dedicated_vpce_config.rest_vpc_endpoint_name
  rest_aws_vpc_endpoint_id  = var.privatelink_dedicated_vpce_config.rest_aws_vpc_endpoint_id
}

################################################################################
# IAM
################################################################################
data "databricks_aws_assume_role_policy" "this" {
  external_id = var.account_id
}

data "databricks_aws_crossaccount_policy" "this" {}

module "iam_cross_account_workspace_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.41.0"

  name   = coalesce(var.iam_cross_account_workspace_role_config.policy_name, "${var.label}-dbx-crossaccount-policy")
  policy = data.databricks_aws_crossaccount_policy.this.json
}

module "iam_cross_account_workspace_role" {
  count   = var.iam_cross_account_workspace_role_enabled ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.41.0"

  role_name                       = coalesce(var.iam_cross_account_workspace_role_config.role_name, "${var.label}-dbx-cross-account")
  create_role                     = var.iam_cross_account_workspace_role_enabled
  create_custom_role_trust_policy = true
  custom_role_trust_policy        = data.databricks_aws_assume_role_policy.this.json
  role_permissions_boundary_arn   = var.iam_cross_account_workspace_role_config.permission_boundary_arn
  role_description                = var.iam_cross_account_workspace_role_config.role_description
  custom_role_policy_arns         = [module.iam_cross_account_workspace_policy.arn]
  tags                            = var.tags
}

# It is required to wait up to 30 seconds after role creation so Databricks would successfuly reference it
resource "time_sleep" "wait_30_seconds" {
  depends_on = [module.iam_cross_account_workspace_role]

  create_duration = "30s"
}

resource "databricks_mws_credentials" "this" {
  account_id       = var.account_id
  credentials_name = "${var.label}-credentials"
  role_arn         = module.iam_cross_account_workspace_role[0].iam_role_arn

  depends_on = [time_sleep.wait_30_seconds]
}

################################################################################
# Storage Configuration
################################################################################
data "databricks_aws_bucket_policy" "this" {
  bucket = module.storage_configuration_dbfs_bucket[0].s3_bucket_id
}

module "storage_configuration_dbfs_bucket" {
  count   = var.storage_dbfs_enabled ? 1 : 0
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket_prefix = coalesce(var.storage_dbfs_config.bucket_name, "${var.label}-dbfs-")
  acl           = "private"

  force_destroy = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    status = "Disabled"
  }

}

resource "aws_s3_bucket_policy" "databricks_aws_bucket_policy" {
  bucket = module.storage_configuration_dbfs_bucket[0].s3_bucket_id
  policy = data.databricks_aws_bucket_policy.this.json
}

resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.account_id
  storage_configuration_name = var.label
  bucket_name                = module.storage_configuration_dbfs_bucket[0].s3_bucket_id
}
