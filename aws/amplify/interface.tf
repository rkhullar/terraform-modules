variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "repository" {
  type = string
}

variable "build_spec" {
  type = string
}

variable "access_token" {
  sensitive = true
  type      = string
  default   = null
}

variable "role" {
  type        = string
  description = "amplify service role arn"
  default     = null
}

variable "create_role" {
  type    = bool
  default = true
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "rules" {
  default = []
  type = set(object({
    status = number
    source = string
    target = string
  }))
}

variable "enable_rules" {
  type    = bool
  default = true
}

variable "branches" {
  default = []
  type = set(object({
    name       = string
    stage      = string
    auto_build = optional(bool)
    basic_auth = optional(bool)
    preview    = optional(bool)
    variables  = optional(map(string))
  }))
  validation {
    condition     = length([for branch in var.branches : branch if !contains(["production", "beta", "development", "experimental", "pull_request"], branch.stage)]) == 0
    error_message = "Allowed Values: stage -> {production | beta | development | experimental | pull_request}."
  }
}

output "domain" {
  value = aws_amplify_app.default.default_domain
}

output "resources" {
  value = zipmap(keys(aws_amplify_branch.default), values(aws_amplify_branch.default)[*].associated_resources)
}