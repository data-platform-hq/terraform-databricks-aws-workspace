output "rest_vpce_id" {
  value       = databricks_mws_vpc_endpoint.rest.vpc_endpoint_id
  description = "The ID of the AWS VPC endpoint associated with the Databricks REST API"
}

output "relay_vpce_id" {
  value       = databricks_mws_vpc_endpoint.relay.vpc_endpoint_id
  description = "The ID of the AWS VPC endpoint associated with the Databricks Relay service"
}
