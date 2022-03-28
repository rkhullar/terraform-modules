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
      ingress = object({
        ports       = optional(list(number))
        port_ranges = optional(list(string))
        sources     = list(string)
      })
      egress = object({
        ports       = optional(list(number))
        port_ranges = optional(list(string))
        targets     = list(string)
      })
    })
  )
  default = {}
  validation {
    condition     = length([]) == 0
    error_message = "TBD <bad key> ."
  }
}