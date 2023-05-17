variable "cluster" {
  type     = string
  nullable = false
}

variable "service" {
  type     = string
  nullable = false
}

variable "enable" {
  default  = {}
  nullable = false
  type = object({
    in  = optional(bool, true)
    out = optional(bool, true)
  })
}

variable "capacity" {
  default  = {}
  nullable = false
  type = object({
    min = optional(number, 1)
    max = optional(number, 8)
  })
}

variable "cooldown" {
  default  = {}
  nullable = false
  type = object({
    in  = optional(number, 60)
    out = optional(number, 60)
  })
}

variable "target" {
  type     = number
  nullable = false
  default  = 75
}

variable "metric" {
  type     = string
  nullable = false
  validation {
    condition     = contains(["ECSServiceAverageCPUUtilization", "ECSServiceAverageMemoryUtilization", "ALBRequestCountPerTarget"], var.metric)
    error_message = "Allowed Values: {ECSServiceAverageCPUUtilization | ECSServiceAverageMemoryUtilization | ALBRequestCountPerTarget}."
  }
}

variable "resource_label" {
  type     = string
  nullable = true
  default  = null
}