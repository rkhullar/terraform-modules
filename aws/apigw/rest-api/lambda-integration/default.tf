resource "aws_api_gateway_method" "default" {
  rest_api_id      = local.rest_api_id
  resource_id      = local.resource_id
  http_method      = upper(var.http_method)
  authorization    = "NONE"
  api_key_required = var.api_key_required
}

resource "aws_api_gateway_integration" "default" {
  rest_api_id             = aws_api_gateway_method.default.rest_api_id
  resource_id             = aws_api_gateway_method.default.resource_id
  http_method             = aws_api_gateway_method.default.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = local.lambda_invoke_arn
}

resource "aws_lambda_permission" "default" {
  for_each      = toset([var.stage_name, "test-invoke-stage"])
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  qualifier     = var.function_alias
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${local.rest_api_exec_arn}/${each.value}/${aws_api_gateway_method.default.http_method}${local.resource_path}"
}