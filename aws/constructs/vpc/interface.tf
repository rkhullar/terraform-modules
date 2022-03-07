# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }
variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

# construct
variable "name" {
  type    = string
  default = "vpc"
}

variable "full_name" {
  type    = string
  default = null
}

# module
variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "zone_count" {
  type    = number
  default = 3
}

variable "flags" {
  type    = map(bool)
  default = {}
}

output "id" {
  value = module.default.id
}

output "debug" {
  value = module.default.debug
}