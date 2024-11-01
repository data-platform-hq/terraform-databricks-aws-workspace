resource "databricks_mws_vpc_endpoint" "rest" {
  account_id          = var.account_id
  aws_vpc_endpoint_id = var.rest_aws_vpc_endpoint_id
  vpc_endpoint_name   = var.rest_vpc_endpoint_name
  region              = var.region
}

resource "databricks_mws_vpc_endpoint" "relay" {
  account_id          = var.account_id
  aws_vpc_endpoint_id = var.relay_aws_vpc_endpoint_id
  vpc_endpoint_name   = var.relay_vpc_endpoint_name
  region              = var.region
}
