# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }
variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

# construct
variable "rules" {
  default = {}
  type = map(
    object({
      ingress = optional(object({
        ports       = optional(list(number))
        port_ranges = optional(list(string))
        sources     = list(string)
      }))
      egress = optional(object({
        ports       = optional(list(number))
        port_ranges = optional(list(string))
        targets     = list(string)
      }))
    })
  )
}

variable "custom_rules" {
  default = []
  type = list(object({
    type        = string # ingress | egress
    protocol    = string # tcp | udp | all
    port        = optional(number)
    port_range  = optional(string)
    source      = string
    target      = string
    description = optional(string)
  }))
}

variable "aliases" {
  type    = map(string)
  default = {}
}

variable "enable_rules" {
  type    = bool
  default = true
}

variable "ingress_protocol" {
  type    = string
  default = "tcp"
}

variable "egress_protocol" {
  type    = string
  default = "tcp"
}

variable "names" {
  type = object({
    load_balancer = optional(string, "load-balancer")
    linux_runtime = optional(string, "linux-runtime")
    data_runtime  = optional(string, "data-runtime")
  })
}

variable "descriptions" {
  default = {}
  type = object({
    load_balancer = optional(string)
    linux_runtime = optional(string)
    data_runtime  = optional(string)
  })
}

# output
output "id" {
  value = local.vpc.id
}

output "cidr" {
  value = local.vpc.cidr
}

output "subnets" {
  value = local.vpc.subnets
}

output "security_groups" {
  value = module.default.security_groups
}