variable cluster {
  type = string
}

variable service {
  type = string
}

variable enable {
  type    = map(bool)
  default = {}
}

variable capacity {
  type    = map(number)
  default = {}
}

variable cooldown {
  type    = map(number)
  default = {}
}

variable target {
  type    = number
  default = null
}

variable metric {
  type    = string
  default = null
}

variable resource_label {
  type    = string
  default = null
}

# defaults
variable enable_defaults {
  type    = object({ in = bool, out = bool })
  default = { in = true, out = true }
}

variable capacity_defaults {
  type    = object({ min = number, max = number })
  default = { min = 1, max = 8 }
}

variable cooldown_defaults {
  type    = object({ in = number, out = number })
  default = { in = 60, out = 60 }
}

variable target_default {
  type    = number
  default = 75
}

variable metric_default {
  type        = string
  default     = "ECSServiceAverageCPUUtilization"
  description = "ECSServiceAverageCPUUtilization | ECSServiceAverageMemoryUtilization | ALBRequestCountPerTarget"
}