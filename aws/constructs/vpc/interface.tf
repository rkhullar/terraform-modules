# general
variable "account" {
  type = string
}
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

variable "nat_zone" {
  type    = number
  default = null
}

variable "subnet_prefix" {
  type    = map(string)
  default = {}
}

# peering
variable "peering_defaults" {
  type = object({
    requests = list(map(string))
    accepts  = list(map(string))
  })
  default = {
    requests = []
    accepts  = []
  }
}
variable "peering" {
  type    = any
  default = {}
}

# routing
variable "routing_defaults" {
  type = object({
    common  = list(map(string))
    public  = list(map(string))
    private = list(map(string))
    data    = list(map(string))
  })
  default = {
    common  = []
    public  = []
    private = []
    data    = []
  }
}
variable "routing" {
  type    = any
  default = {}
}


# outputs
output "id" {
  value = module.default.id
}

output "cidr" {
  value = module.default.cidr
}

output "subnets" {
  value = module.default.subnets
}