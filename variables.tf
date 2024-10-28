################################################################################
# General 
################################################################################
variable "label" {
  description = "A customizable string used as a prefix for naming Databricks resources"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Assigned tags to AWS services"
  type        = map(string)
  default     = {}
}

variable "account_id" {
  description = "Databricks Account ID"
  type        = string
}

################################################################################
# Network configuration
################################################################################
variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string
}

variable "security_group_ids" {
  description = "Set of AWS security group IDs for Databricks Account network configuration"
  type        = set(string)
}

variable "subnet_ids" {
  description = "Set of AWS subnet IDs for Databricks Account network configuration"
  type        = set(string)
}

################################################################################
# Privatelink configuration
################################################################################
variable "privatelink_enabled" {
  type        = bool
  description = "Boolean flag to enabled registration of Privatelink VPC Endpoints (REST API and SCC Relay) in target Databricks Network Config"
  default     = false
}

variable "privatelink_rest_vpce_id" {
  type        = string
  description = "AWS VPC Endpoint ID used for Databricks REST API if PrivateLink is enabled"
  default     = null

  validation {
    error_message = "It is required to provide AWS VPC Endpoints for Databricks REST API in case Privatelink enabled"
    condition     = var.privatelink_enabled ? var.privatelink_rest_vpce_id != null : true
  }
}

variable "privatelink_relay_vpce_id" {
  description = "AWS VPC Endpoint ID used for Databricks SCC Relay when PrivateLink is enabled"
  type        = string
  default     = null

  validation {
    error_message = "It is required to provide AWS VPC Endpoints for Databricks SCC Relay in case Privatelink enabled"
    condition     = var.privatelink_enabled ? var.privatelink_relay_vpce_id != null : true
  }
}

variable "privatelink_dedicated_vpce_enabled" {
  description = "Boolean flag to enable or disable the creation of dedicated AWS VPC Endpoints (VPCe) for Databricks PrivateLink"
  type        = bool
  default     = false
}

variable "privatelink_dedicated_vpce_config" {
  description = "Configuration object for AWS PrivateLink dedicated VPC Endpoints (VPCe)"
  type = object({
    rest_vpc_endpoint_name    = optional(string, null)
    relay_vpc_endpoint_name   = optional(string, null)
    rest_aws_vpc_endpoint_id  = optional(string, null)
    relay_aws_vpc_endpoint_id = optional(string, null)
  })
  default = {}
}

################################################################################
# Databricks Workspace
################################################################################
variable "iam_cross_account_workspace_role_enabled" {
  description = "A boolean flag to determine if the cross-account IAM role for Databricks workspace access should be created"
  type        = bool
  default     = true
}

variable "iam_cross_account_workspace_role_config" {
  description = "Configuration object for setting the IAM cross-account role for the Databricks workspace"
  type = object({
    role_name               = optional(string, null)
    policy_name             = optional(string, null)
    permission_boundary_arn = optional(string, null)
    role_description        = optional(string, "Databricks IAM Role to launch clusters in your AWS account, you must create a cross-account IAM role that gives access to Databricks.")
  })
  default = {}
}

################################################################################
# Storage root bucket config
################################################################################
variable "storage_dbfs_enabled" {
  description = "Flag to enable or disable the use of DBFS (Databricks File System) storage in the Databricks workspace"
  type        = bool
  default     = true
}

variable "storage_dbfs_config" {
  description = "Configuration for the Databricks File System (DBFS) storage"
  type = object({
    bucket_name = optional(string)
  })
  default = {}
}

################################################################################
# Workspace
################################################################################
variable "workspace_creator_token_enabled" {
  description = "Indicates whether to enable the creation of a token for workspace creators in Databricks"
  type        = bool
  default     = false
}

################################################################################
# Workspace access config
################################################################################
variable "private_access_settings_enabled" {
  description = "Indicates whether private access settings should be enabled for the Databricks workspace. Set to true to activate these settings"
  type        = bool
  default     = true
}

variable "private_access_settings_config" {
  description = "Configuration for private access settings"
  type = object({
    name                     = optional(string, null)
    allowed_vpc_endpoint_ids = optional(list(string), [])
    public_access_enabled    = optional(bool, true)
  })
  default = {}
}
