variable "vpc_id" {
  type = string
}

variable "tags" {
  type     = map(string)
  default  = {}
  nullable = false
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
  type = set(string)
}

variable "descriptions" {
  type     = map(string)
  default  = {}
  nullable = false
}

variable "aliases" {
  type        = map(string)
  description = "name -> source"
  default     = {}
  nullable    = false
}

variable "enable_rules" {
  type     = bool
  default  = true
  nullable = false
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
  default  = []
  nullable = false
}

output "security_groups" {
  value = local.security_groups
}

output "debug" {
  value = {
    names        = var.names
    descriptions = var.descriptions
    aliases      = var.aliases
    enable_rules = var.enable_rules
    rules        = var.rules
    prefix       = var.prefix
    suffix       = var.suffix
  }
}