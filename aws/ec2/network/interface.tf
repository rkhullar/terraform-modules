variable "vpc_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "names" {
  type = object({
    load_balancer = optional(string)
    linux_runtime = optional(string)
    data_runtime  = optional(string)
  })
  default = {}
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

output "security_groups" {
  value = {
    load_balancer = module.load-balancer.id
    linux_runtime = module.linux-runtime.id
    data_runtime  = module.data-runtime.id
  }
}