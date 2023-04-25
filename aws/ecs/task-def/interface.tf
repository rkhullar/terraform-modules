# task
variable "family" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "roles" {
  type = object({
    task = optional(string),
    exec = optional(string) # required when using container secrets
  })
}

variable "network_mode" {
  type     = string
  nullable = false
  default  = "awsvpc"
  validation {
    condition     = contains(["none", "bridge", "awsvpc", "host"], var.network_mode)
    error_message = "Allowed Values: {none | bridge | awsvpc | host}."
  }
}

variable "launch_types" {
  type     = list(string)
  nullable = false
  default  = []
  validation {
    condition     = length([for value in var.launch_types : value if !contains(["ec2", "fargate"], value)]) == 0
    error_message = "Allowed Values: {ec2 | fargate}."
  }
}

# container
variable "image" {
  type     = string
  nullable = false
}

variable "container" {
  type     = string
  nullable = true
  default  = null
}

variable "envs" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "secrets" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "ignore_case" {
  type     = bool
  nullable = false
  default  = false
}

variable "ports" {
  type     = list(number)
  nullable = false
  default  = [8000]
}

variable "entrypoint" {
  type     = list(string)
  nullable = true
  default  = []
}

variable "command" {
  type     = list(string)
  nullable = true
  default  = []
}

# logging
variable "logging" {
  nullable = false
  type = object({
    group  = string
    prefix = optional(string, "default"),
    region = optional(string)
  })
}

variable "ulimits" {
  default  = []
  nullable = false
  type = list(object({
    name       = string
    hard-limit = number
    soft-limit = number
  }))
}

variable "flags" {
  nullable = false
  type = object({
    enabled     = optional(bool, true)
    essential   = optional(bool, true)
    docker-init = optional(bool, false)
    privileged  = optional(bool, false)
  })
}

variable "volumes" {
  default  = []
  nullable = false
  type = list(object({
    name = string
    type = string
    bind_mount = optional(object({
      host_path = string
    }))
    docker = optional(object({
      scope         = optional(string) # task | shared
      autoprovision = optional(bool)
      driver        = optional(string)
      driver_opts   = optional(map(string))
      labels        = optional(map(string))
    }))
    efs = optional(object({
      id              = string
      root_directory  = optional(string)
      encrypt         = optional(bool, false)
      transit_port    = optional(number)
      access_point_id = optional(string)
      enable_iam      = optional(bool, false)
    }))
  }))
  validation {
    condition     = length([for item in var.volumes : item if !contains(["bind_mount", "docker", "efs"], item["type"])]) == 0
    error_message = "Allowed Values: type -> {bind_mount | docker | efs}."
  }
}

variable "mount_points" {
  default  = []
  nullable = false
  type = list(object({
    volume         = string
    container_path = string
    read_only      = bool
  }))
}

# sizing
variable "sizing" {
  type = object({
    task = object({
      cpu    = optional(number)
      memory = optional(number)
    })
    container = object({
      cpu                = optional(number)
      memory             = optional(number)
      memory-reservation = optional(number)
    })
  })
}

# outputs
output "default" {
  value = one(aws_ecs_task_definition.default)
}

output "container" {
  value = local.container_definition
}