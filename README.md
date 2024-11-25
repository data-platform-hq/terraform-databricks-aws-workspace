# AWS Databricks Workspace Terraform module
Terraform module for creation AWS Databricks Workspace

## Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | ~>1.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>5.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | ~>1.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.11 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_cross_account_workspace_policy"></a> [iam\_cross\_account\_workspace\_policy](#module\_iam\_cross\_account\_workspace\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | 5.41.0 |
| <a name="module_iam_cross_account_workspace_role"></a> [iam\_cross\_account\_workspace\_role](#module\_iam\_cross\_account\_workspace\_role) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | 5.41.0 |
| <a name="module_privatelink_vpce"></a> [privatelink\_vpce](#module\_privatelink\_vpce) | ./modules/privatelink/ | n/a |
| <a name="module_storage_configuration_dbfs_bucket"></a> [storage\_configuration\_dbfs\_bucket](#module\_storage\_configuration\_dbfs\_bucket) | terraform-aws-modules/s3-bucket/aws | 4.1.2 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_policy.databricks_aws_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [databricks_mws_credentials.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials) | resource |
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks) | resource |
| [databricks_mws_private_access_settings.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_private_access_settings) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces) | resource |
| [time_sleep.wait_30_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [databricks_aws_assume_role_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy) | data source |
| [databricks_aws_bucket_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy) | data source |
| [databricks_aws_crossaccount_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_crossaccount_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Databricks Account ID | `string` | n/a | yes |
| <a name="input_iam_cross_account_workspace_role_config"></a> [iam\_cross\_account\_workspace\_role\_config](#input\_iam\_cross\_account\_workspace\_role\_config) | Configuration object for setting the IAM cross-account role for the Databricks workspace | <pre>object({<br/>    role_name               = optional(string, null)<br/>    policy_name             = optional(string, null)<br/>    permission_boundary_arn = optional(string, null)<br/>    role_description        = optional(string, "Databricks IAM Role to launch clusters in your AWS account, you must create a cross-account IAM role that gives access to Databricks.")<br/>  })</pre> | `{}` | no |
| <a name="input_iam_cross_account_workspace_role_enabled"></a> [iam\_cross\_account\_workspace\_role\_enabled](#input\_iam\_cross\_account\_workspace\_role\_enabled) | A boolean flag to determine if the cross-account IAM role for Databricks workspace access should be created | `bool` | `true` | no |
| <a name="input_label"></a> [label](#input\_label) | A customizable string used as a prefix for naming Databricks resources | `string` | n/a | yes |
| <a name="input_private_access_settings_config"></a> [private\_access\_settings\_config](#input\_private\_access\_settings\_config) | Configuration for private access settings | <pre>object({<br/>    name                     = optional(string, null)<br/>    allowed_vpc_endpoint_ids = optional(list(string), [])<br/>    public_access_enabled    = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_private_access_settings_enabled"></a> [private\_access\_settings\_enabled](#input\_private\_access\_settings\_enabled) | Indicates whether private access settings should be enabled for the Databricks workspace. Set to true to activate these settings | `bool` | `true` | no |
| <a name="input_privatelink_dedicated_vpce_config"></a> [privatelink\_dedicated\_vpce\_config](#input\_privatelink\_dedicated\_vpce\_config) | Configuration object for AWS PrivateLink dedicated VPC Endpoints (VPCe) | <pre>object({<br/>    rest_vpc_endpoint_name    = optional(string, null)<br/>    relay_vpc_endpoint_name   = optional(string, null)<br/>    rest_aws_vpc_endpoint_id  = optional(string, null)<br/>    relay_aws_vpc_endpoint_id = optional(string, null)<br/>  })</pre> | `{}` | no |
| <a name="input_privatelink_dedicated_vpce_enabled"></a> [privatelink\_dedicated\_vpce\_enabled](#input\_privatelink\_dedicated\_vpce\_enabled) | Boolean flag to enable or disable the creation of dedicated AWS VPC Endpoints (VPCe) for Databricks PrivateLink | `bool` | `false` | no |
| <a name="input_privatelink_enabled"></a> [privatelink\_enabled](#input\_privatelink\_enabled) | Boolean flag to enabled registration of Privatelink VPC Endpoints (REST API and SCC Relay) in target Databricks Network Config | `bool` | `false` | no |
| <a name="input_privatelink_relay_vpce_id"></a> [privatelink\_relay\_vpce\_id](#input\_privatelink\_relay\_vpce\_id) | AWS VPC Endpoint ID used for Databricks SCC Relay when PrivateLink is enabled | `string` | `null` | no |
| <a name="input_privatelink_rest_vpce_id"></a> [privatelink\_rest\_vpce\_id](#input\_privatelink\_rest\_vpce\_id) | AWS VPC Endpoint ID used for Databricks REST API if PrivateLink is enabled | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Set of AWS security group IDs for Databricks Account network configuration | `set(string)` | n/a | yes |
| <a name="input_storage_dbfs_config"></a> [storage\_dbfs\_config](#input\_storage\_dbfs\_config) | Configuration for the Databricks File System (DBFS) storage | <pre>object({<br/>    bucket_name = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_storage_dbfs_enabled"></a> [storage\_dbfs\_enabled](#input\_storage\_dbfs\_enabled) | Flag to enable or disable the use of DBFS (Databricks File System) storage in the Databricks workspace | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Set of AWS subnet IDs for Databricks Account network configuration | `set(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Assigned tags to AWS services | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | AWS VPC ID | `string` | n/a | yes |
| <a name="input_workspace_creator_token_enabled"></a> [workspace\_creator\_token\_enabled](#input\_workspace\_creator\_token\_enabled) | Indicates whether to enable the creation of a token for workspace creators in Databricks | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | The IAM role created for cross-account access to the Databricks workspace |
| <a name="output_storage"></a> [storage](#output\_storage) | The storage configuration for the DBFS bucket associated with the workspace |
| <a name="output_workspace"></a> [workspace](#output\_workspace) | The Databricks workspace resource that has been created |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The unique identifier of the Databricks workspace. |
| <a name="output_workspace_url"></a> [workspace\_url](#output\_workspace\_url) | The URL for accessing the Databricks workspace |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](./LICENSE)
