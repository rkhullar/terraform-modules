resource "aws_api_gateway_rest_api" "default" {
  name                         = var.name
  tags                         = var.tags
  disable_execute_api_endpoint = var.flags.disable_default_endpoint
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "default" {
  depends_on  = [module.lambda-integrations]
  rest_api_id = aws_api_gateway_rest_api.default.id
}

resource "aws_api_gateway_stage" "default" {
  rest_api_id   = aws_api_gateway_deployment.default.rest_api_id
  deployment_id = aws_api_gateway_deployment.default.id
  stage_name    = "default"
  tags          = var.tags
  lifecycle {
    ignore_changes = [deployment_id, cache_cluster_size]
  }
}

resource "aws_api_gateway_resource" "default" {
  for_each    = toset(distinct([for route in var.routes : route["path"]]))
  rest_api_id = aws_api_gateway_rest_api.default.id
  parent_id   = aws_api_gateway_rest_api.default.root_resource_id
  path_part   = trimprefix(each.value, "/")
}

module "lambda-integrations" {
  depends_on       = [aws_api_gateway_resource.default]
  for_each         = { for route in var.routes : "${upper(route["method"])} ${route["path"]}" => route }
  source           = "./lambda-integration"
  rest_api_name    = aws_api_gateway_rest_api.default.name
  resource_path    = each.value["path"]
  http_method      = each.value["method"]
  api_key_required = each.value["require_api_key"]
  stage_name       = "default"
  function_name    = var.lambda_function_name
  function_alias   = var.lambda_function_alias
}