# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }
variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

# construct
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

# output
output "managed" {
  value = module.default.managed
}

output "secrets" {
  value = module.default.secrets
}

output "custom" {
  value = module.default.custom
}