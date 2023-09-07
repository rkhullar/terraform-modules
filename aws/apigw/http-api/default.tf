data "aws_lambda_function" "default" {
  function_name = var.lambda_function_name
}

locals {
  enable_cors           = length(var.allowed_origins) > 0
  enable_jwt_authorizer = var.flags.enable_jwt_authorizer && var.jwt_auth != null
  lambda_arn_parts      = compact([data.aws_lambda_function.default.arn, var.lambda_function_alias])
  lambda_arn            = join(":", local.lambda_arn_parts)
}

resource "aws_apigatewayv2_api" "default" {
  name                         = var.name
  tags                         = var.tags
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = var.flags.disable_default_endpoint

  dynamic "cors_configuration" {
    for_each = local.enable_cors ? [true] : []
    content {
      allow_origins = var.allowed_origins
      allow_methods = var.allowed_methods
      allow_headers = ["authorization"]
    }
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.default.id
  name        = "$default"
  tags        = var.tags
  auto_deploy = var.flags.auto_deploy

  dynamic "access_log_settings" {
    for_each = var.flags.enable_logs ? [true] : []
    content {
      destination_arn = aws_cloudwatch_log_group.default[0].arn
      format          = jsonencode(var.log_context)
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  count = var.flags.enable_logs ? 1 : 0
  name  = var.name
  tags  = var.tags
}

resource "aws_apigatewayv2_route" "default" {
  for_each           = var.flags.enable_proxy_route ? var.allowed_methods : []
  api_id             = aws_apigatewayv2_api.default.id
  route_key          = "${upper(each.value)} /{proxy+}"
  authorization_type = local.enable_jwt_authorizer ? "JWT" : null
  authorizer_id      = local.enable_jwt_authorizer ? aws_apigatewayv2_authorizer.jwt[0].id : null
  target             = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id                 = aws_apigatewayv2_api.default.id
  integration_type       = "AWS_PROXY"
  integration_uri        = local.lambda_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  count            = local.enable_jwt_authorizer ? 1 : 0
  api_id           = aws_apigatewayv2_api.default.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = var.jwt_auth.name
  jwt_configuration {
    issuer   = var.jwt_auth.issuer
    audience = [var.jwt_auth.audience]
  }
}

resource "aws_lambda_permission" "default" {
  count         = var.flags.create_lambda_permission && var.flags.enable_proxy_route ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.default.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.default.execution_arn}/$default/*/{proxy+}"
  qualifier     = var.lambda_function_alias
}

locals {
  extra_routes_map = { for item in var.extra_routes : "${upper(item["method"])} ${item["path"]}" => item }
}

resource "aws_apigatewayv2_route" "extra" {
  for_each             = local.extra_routes_map
  api_id               = aws_apigatewayv2_api.default.id
  route_key            = each.key
  authorization_type   = each.value["require_jwt"] ? "JWT" : null
  authorizer_id        = each.value["require_jwt"] ? aws_apigatewayv2_authorizer.jwt[0].id : null
  authorization_scopes = each.value["scopes"]
  target               = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_lambda_permission" "extra" {
  for_each      = var.flags.create_lambda_permission ? local.extra_routes_map : {}
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.default.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.default.execution_arn}/$default/${upper(each.value["method"])}${each.value["path"]}"
  qualifier     = var.lambda_function_alias
}