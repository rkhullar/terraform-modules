# variables
variable "managed" {
  type    = map(string)
  default = {}
}

variable "secrets" {
  type    = list(string)
  default = []
}

variable "custom" {
  type    = list(object({ name = string, type = string, value = string }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "prefix" {
  type    = string
  default = "/"
}

# output
output "managed" {
  value = { for key, param in aws_ssm_parameter.managed : key => param.name }
}

output "secrets" {
  value = { for key, param in aws_ssm_parameter.secret : key => param.name }
}

output "custom" {
  value = { for key, param in aws_ssm_parameter.custom : key => param.name }
}