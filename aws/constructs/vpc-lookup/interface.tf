# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }
variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

# remotes
variable "shared" {
  type    = bool
  default = true
}

variable "remote_environment" {
  type    = string
  default = null
}

# outputs
/*
output "id" {
  value = local.mapping.id
}

output "cidr" {
  value = local.mapping.cidr
}

output "subnets" {
  value = local.mapping.subnets
}
*/

output "debug" {
  value = { remote = local.remote, bucket = local.bucket }
}