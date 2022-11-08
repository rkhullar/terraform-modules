variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  default  = {}
  nullable = false
}

variable "lambda_function_name" {
  type     = string
  nullable = false
}

variable "flags_default" {
  nullable = false
  type = object({
    auto_deploy              = bool
    disable_default_endpoint = bool
    create_lambda_permission = bool
    enable_jwt_authorizer    = bool
  })
  default = {
    auto_deploy              = true
    disable_default_endpoint = true
    create_lambda_permission = true
    enable_jwt_authorizer    = true
  }
}

variable "flags" {
  type     = map(bool)
  default  = {}
  nullable = false
}

variable "jwt_auth_default" {
  nullable = false
  type = object({
    name     = string
    issuer   = string
    audience = string
  })
  default = {
    name     = null
    issuer   = null
    audience = null
  }
}

variable "jwt_auth" {
  type     = map(string)
  default  = {}
  nullable = false
}

locals {
  flags    = merge(var.flags_default, var.flags)
  jwt_auth = merge(var.jwt_auth_default, var.jwt_auth)
}

# output
output "api_id" {
  value = aws_apigatewayv2_api.default.id
}

output "stage_id" {
  value = aws_apigatewayv2_stage.default.id
}