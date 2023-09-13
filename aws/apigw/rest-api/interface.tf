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
    disable_default_endpoint = optional(bool, true)
    create_lambda_permission = optional(bool, true)
  })
}

variable "routes" {
  # NOTE: route paths must be at the root level for now
  type = list(object({
    method          = string
    path            = string
    require_api_key = optional(bool, false)
  }))
}

# output
output "api_id" {
  value = aws_api_gateway_rest_api.default.id
}

output "stage_name" {
  value = aws_api_gateway_stage.default.stage_name
}