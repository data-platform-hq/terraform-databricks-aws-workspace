output "workspace" {
  value       = databricks_mws_workspaces.this
  description = "The Databricks workspace resource that has been created"
}

output "storage" {
  value       = try(module.storage_configuration_dbfs_bucket[0], null)
  description = "The storage configuration for the DBFS bucket associated with the workspace"
}

output "iam_role" {
  value       = try(module.iam_cross_account_workspace_role[0], null)
  description = "The IAM role created for cross-account access to the Databricks workspace"
}

output "workspace_url" {
  value       = databricks_mws_workspaces.this.workspace_url
  description = "The URL for accessing the Databricks workspace"
}

output "workspace_id" {
  value       = databricks_mws_workspaces.this.workspace_id
  description = "The unique identifier of the Databricks workspace."
}
