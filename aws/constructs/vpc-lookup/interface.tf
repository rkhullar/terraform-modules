# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }
variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

# remotes
variable "remote_defaults" {
  type = object({
    account     = bool
    environment = string
  })
  default = {
    account     = true
    environment = null
  }
}

variable "remote" {
  type    = any
  default = null
}

# outputs
output "id" {
  value = local.mapping.id
}

output "cidr" {
  value = local.mapping.cidr
}

output "subnets" {
  value = local.mapping.subnets
}