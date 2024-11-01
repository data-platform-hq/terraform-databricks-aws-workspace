variable "region" {
  type        = string
  description = "AWS region"
}

variable "rest_vpc_endpoint_name" {
  type        = string
  description = "The name to assign to the AWS VPC endpoint for the Databricks REST API"
}
variable "rest_aws_vpc_endpoint_id" {
  type        = string
  description = "The AWS VPC endpoint ID for the Databricks REST API"
}

variable "relay_vpc_endpoint_name" {
  type        = string
  description = "The name to assign to the AWS VPC endpoint for the Databricks Relay service"
}

variable "relay_aws_vpc_endpoint_id" {
  type        = string
  description = "The AWS VPC endpoint ID for the Databricks Relay service"
}

variable "account_id" {
  type        = string
  description = "Databricks Account ID"
}
