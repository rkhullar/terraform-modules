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

variable "handler" {
  type     = string
  nullable = false
}

variable "runtime" {
  type     = string
  nullable = false
}

variable "memory" { default = 128 }
variable "template" { default = "api-gw-hello" }
variable "timeout" { default = 30 }

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

variable "layers" {
  type     = list(string)
  default  = []
  nullable = false
}

variable "reserved_concurrent_executions" {
  type     = number
  default  = -1 # set to -1 to remove all concurrency limitations
  nullable = true
}

output "output" {
  value = aws_lambda_function.default
}