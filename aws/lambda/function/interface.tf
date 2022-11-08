variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "role" {
  type     = string
  nullable = false
}

variable "runtime" {
  type     = string
  nullable = false
}

variable "handler" {
  type     = string
  nullable = false
}

variable "template" {
  type     = string
  default  = "default"
  nullable = false
}

variable "architecture" {
  type     = string
  default  = "x86_64"
  nullable = false
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "Allowed Values: architecture -> {x86_64, arm64}."
  }
}

variable "memory" {
  type     = number
  default  = 128
  nullable = true
}

variable "timeout" {
  type     = number
  default  = 3
  nullable = false
}

variable "environment" {
  type     = map(string)
  default  = {}
  nullable = false
}

variable "ignore_case" {
  type     = bool
  default  = false
  nullable = false
}

variable "layers" {
  type     = list(string)
  default  = []
  nullable = false
}

variable "publish" {
  type     = bool
  default  = false
  nullable = true
}

variable "reserved_concurrent_executions" {
  type        = number
  default     = -1
  nullable    = true
  description = "0 disables the lambda; -1 removes concurrency limits"
}

variable "security_groups" {
  type     = list(string)
  default  = []
  nullable = true
}

variable "subnets" {
  type     = list(string)
  default  = []
  nullable = true
}

output "output" {
  value = aws_lambda_function.default
}