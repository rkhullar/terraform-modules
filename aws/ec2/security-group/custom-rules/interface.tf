variable "enable" {
  type     = bool
  nullable = false
  default  = true
}

variable "rules" {
  type = list(object({
    type        = string # ingress | egress
    protocol    = string # tcp | udp | all
    port        = optional(number)
    port_range  = optional(string)
    source      = string
    target      = string
    description = optional(string)
  }))
  nullable = false
  default  = []
  validation {
    condition     = length([for rule in var.rules : rule if !contains(["ingress", "egress"], rule.type)]) == 0
    error_message = "Allowed Values: type -> {ingress | egress}."
  }
  validation {
    condition     = length([for rule in var.rules : rule if !contains(["tcp", "udp", "all", "-1"], rule.protocol)]) == 0
    error_message = "Allowed Values: protocol -> {tcp | udp | all}."
  }
  validation {
    condition     = length([for rule in var.rules : rule if(rule.port == null && rule.port_range == null) || (rule.port != null && rule.port_range != null)]) == 0
    error_message = "Mutually Exclusive: [port, port_range]."
  }
}

variable "aliases" {
  type        = map(string)
  nullable    = false
  default     = {}
  description = "name -> source"
}

output "detail" {
  value = local.detail_map
}