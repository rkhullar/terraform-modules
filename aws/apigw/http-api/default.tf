data "aws_lambda_function" "default" {
  function_name = var.lambda_function_name
}

resource "aws_apigatewayv2_api" "default" {
  name                         = var.name
  tags                         = var.tags
  protocol_type                = "HTTP"
  disable_execute_api_endpoint = local.flags["disable_default_endpoint"]
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.default.id
  name        = "$default"
  tags        = var.tags
  auto_deploy = local.flags["auto_deploy"]
}

resource "aws_apigatewayv2_route" "default" {
  api_id             = aws_apigatewayv2_api.default.id
  route_key          = "$default"
  authorization_type = local.flags["enable_jwt_authorizer"] ? "JWT" : null
  authorizer_id      = local.flags["enable_jwt_authorizer"] ? aws_apigatewayv2_authorizer.jwt[0].id : null
  target             = "integrations/${aws_apigatewayv2_integration.default.id}"
}

resource "aws_apigatewayv2_integration" "default" {
  api_id                 = aws_apigatewayv2_api.default.id
  integration_type       = "AWS_PROXY"
  integration_uri        = data.aws_lambda_function.default.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_authorizer" "jwt" {
  count            = local.flags["enable_jwt_authorizer"] ? 1 : 0
  api_id           = aws_apigatewayv2_api.default.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = coalesce(local.jwt_auth["name"], var.name)
  jwt_configuration {
    issuer   = local.jwt_auth["issuer"]
    audience = [local.jwt_auth["audience"]]
  }
}

resource "aws_lambda_permission" "default" {
  count         = local.flags["create_lambda_permission"] ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.default.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.default.execution_arn}/*/$default"
}