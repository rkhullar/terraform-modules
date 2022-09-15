variable "vpc_id" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "prefix" {
  type    = string
  default = null
}

variable "suffix" {
  type    = string
  default = null
}

variable "names" {
  type     = set(string)
  nullable = false
}

variable "descriptions" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "aliases" {
  type        = map(string)
  nullable    = false
  description = "name -> source"
  default     = {}
}

variable "enable_rules" {
  type     = bool
  nullable = false
  default  = true
}

variable "rules" {
  type = set(object({
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
}

output "security_groups" {
  value = local.security_groups
}