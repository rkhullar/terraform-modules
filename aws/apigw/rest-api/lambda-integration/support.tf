data "aws_region" "default" {}
data "aws_caller_identity" "default" {}

locals {
  region     = data.aws_region.default.name
  account_id = data.aws_caller_identity.default.account_id
}

data "aws_api_gateway_rest_api" "default" {
  name = var.rest_api_name
}

data "aws_api_gateway_resource" "default" {
  # NOTE: path must be prefixed with "/"
  rest_api_id = local.rest_api_id
  path        = var.resource_path
}

locals {
  rest_api_id       = data.aws_api_gateway_rest_api.default.id
  rest_api_exec_arn = data.aws_api_gateway_rest_api.default.execution_arn
  resource_id       = data.aws_api_gateway_resource.default.id
  resource_path     = data.aws_api_gateway_resource.default.path
}

locals {
  # lambda_invoke_arn = data.aws_lambda_function.default.invoke_arn
  # NOTE: building lambda invoke arn manually to avoid version / qualifier suffix
  integration_uri_prefix = "arn:aws:apigateway:${local.region}:lambda:path/2015-03-31/functions"
  lambda_arn_parts       = compact(["arn", "aws", "lambda", local.region, local.account_id, "function", var.function_name, var.function_alias])
  lambda_arn             = join(":", local.lambda_arn_parts) # "arn:aws:lambda:${local.region}:${local.account_id}:function:${var.function_name}"
  lambda_invoke_arn      = "${local.integration_uri_prefix}/${local.lambda_arn}/invocations"
}