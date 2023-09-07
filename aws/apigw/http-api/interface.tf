variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "lambda_function_name" {
  type     = string
  nullable = false
}

variable "lambda_function_alias" {
  type     = string
  nullable = true
  default  = null
}

variable "flags" {
  default  = {}
  nullable = false
  type = object({
    auto_deploy              = optional(bool, true)
    disable_default_endpoint = optional(bool, true)
    create_lambda_permission = optional(bool, true)
    enable_jwt_authorizer    = optional(bool, true)
    enable_proxy_route       = optional(bool, true)
    enable_logs              = optional(bool, true)
  })
}

variable "jwt_auth" {
  default  = null
  nullable = true
  type = object({
    name     = string
    issuer   = string
    audience = string
  })
}

variable "allowed_methods" {
  type     = set(string)
  default  = ["get", "post", "put", "delete"]
  nullable = false
}

variable "allowed_origins" {
  type     = set(string)
  default  = []
  nullable = false
}

variable "extra_routes" {
  default  = []
  nullable = false
  type = list(object({
    method      = string
    path        = string
    require_jwt = optional(bool, false)
    scopes      = optional(list(string))
  }))
}

variable "log_context" {
  type     = map(string)
  nullable = false
  default = {
    httpMethod     = "$context.httpMethod"
    ip             = "$context.identity.sourceIp"
    protocol       = "$context.protocol"
    requestId      = "$context.requestId"
    requestTime    = "$context.requestTime"
    responseLength = "$context.responseLength"
    routeKey       = "$context.routeKey"
    status         = "$context.status"
  }
}

# output
output "api_id" {
  value = aws_apigatewayv2_api.default.id
}

output "stage_id" {
  value = aws_apigatewayv2_stage.default.id
}