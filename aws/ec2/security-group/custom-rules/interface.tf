variable "enable" {
  type    = bool
  default = true
}

variable "rules" {
  type = list(object({
    type       = string # ingress | egress
    protocol   = string # tcp | udp | all
    port       = optional(number)
    port_range = optional(string)
    source     = string
    target     = string
  }))
  default = []
  validation {
    condition     = length([for rule in var.rules : rule if !contains(["ingress", "egress"], rule.type)]) == 0
    error_message = "Allowed Values: type -> {ingress | egress}."
  }
  validation {
    condition     = length([for rule in var.rules : rule if !contains(["tcp", "udp", "all", "-1"], rule.protocol)]) == 0
    error_message = "Allowed Values: protocol -> {tcp | udp | all}."
  }
}

variable "aliases" {
  type        = map(string)
  description = "name -> source"
  default     = {}
}

output "debug" {
  value = local.location_type_map
}