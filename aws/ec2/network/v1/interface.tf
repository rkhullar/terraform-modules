variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "names" {
  type = object({
    load_balancer = optional(string, "load-balancer", "security group for load balancer")
    linux_runtime = optional(string, "linux-runtime", "security group for linux runtime")
    data_runtime  = optional(string, "data-runtime", "security group for data runtime")
  })
}

variable "descriptions" {
  type = object({
    load_balancer = optional(string)
    linux_runtime = optional(string)
    data_runtime  = optional(string)
  })
  default = {}
}

variable "rules" {
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
  default = {}
  validation {
    condition     = length([for key in keys(var.rules) : key if !contains(["load_balancer", "linux_runtime", "data_runtime"], key)]) == 0
    error_message = "Allowed Keys: {load_balancer | linux_runtime | data_runtime}."
  }
}

variable "aliases" {
  type        = map(string)
  description = "name -> source"
  default     = {}
}

variable "enable_rules" {
  type    = bool
  default = true
}

variable "ingress_protocol" {
  type    = string
  default = "tcp"
  validation {
    condition     = contains(["tcp", "udp", "all", "-1"], var.ingress_protocol)
    error_message = "Allowed Values: {tcp | udp | all}."
  }
}

variable "egress_protocol" {
  type    = string
  default = "tcp"
  validation {
    condition     = contains(["tcp", "udp", "all", "-1"], var.egress_protocol)
    error_message = "Allowed Values: {tcp | udp | all}."
  }
}

variable "custom_rules" {
  type = list(object({
    type        = string # ingress | egress
    protocol    = string # tcp | udp | all
    port        = optional(number)
    port_range  = optional(string)
    source      = string
    target      = string
    description = optional(string)
  }))
  default = []
}

output "security_groups" {
  value = local.security_groups
}