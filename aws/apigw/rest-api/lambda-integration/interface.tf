variable "rest_api_name" {
  type     = string
  nullable = false
}

variable "resource_path" {
  type     = string
  nullable = false
  validation {
    condition     = length(var.resource_path) > 0 && substr(var.resource_path, 0, 1) == "/"
    error_message = "The resource_path value must start with /."
  }
}

variable "http_method" {
  type     = string
  nullable = false
}

variable "api_key_required" {
  type     = bool
  nullable = false
  default  = true
}

variable "function_name" {
  type     = string
  nullable = false
}

variable "function_alias" {
  type     = string
  nullable = true
  default  = null
}

variable "stage_name" {
  type     = string
  nullable = false
}