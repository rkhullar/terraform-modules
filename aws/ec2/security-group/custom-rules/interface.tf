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
}

variable "aliases" {
  type        = map(string)
  description = "name -> source"
  default     = {}
}

output "debug" {
  value = local.location_type_map
}