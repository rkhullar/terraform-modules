variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "propagate_tags" {
  type    = bool
  default = true
}

variable "params" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type    = map(string)
  default = {}
}

variable "ignore_case" {
  type    = bool
  default = false
}

variable "attempts" {
  type    = number
  default = null
}

variable "duration" {
  type    = number
  default = null
}

variable "image" {
  type = string
}

variable "command" {
  type = list(string)
}

variable "roles" {
  type = object({
    exec = string
    task = string
  })
  default = {
    exec = null
    task = null
  }
}

variable "fargate_platform_version" {
  type    = string
  default = "1.4.0"
}

variable "resources" {
  type = object({
    gpu    = number
    vcpu   = number
    memory = number
  })
}

variable "mount_points" {
  type    = list(object({ source_volume = string, container_path = string, read_only = bool }))
  default = []
}

variable "volumes" {
  type    = list(object({ name = string, file_system = string, access_point = string }))
  default = []
}