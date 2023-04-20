// names
variable name {
  type = string
}

variable type {
  type        = string
  default     = "application"
  description = "application | network"
}

variable tags {
  type    = map(string)
  default = {}
}

// network
variable vpc_id {
  type = string
}

variable internal {
  type = bool
}

variable subnets {
  type = list(string)
}

variable security_groups {
  type = list(string)
}

// logs
variable access_logs {
  type    = object({ enabled = bool, bucket = string, prefix = string })
  default = null
}

variable target_groups {
  type    = any
  default = []
}

variable listeners {
  type    = any
  default = []
}

// misc
variable idle_timeout {
  type    = number
  default = 60
}

variable default_ssl_policy {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}
