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
    condition     = contains(["none", "bridge", "task", "host"], var.network_mode)
    error_message = "Allowed Values: {none | bridge | task | host}."
  }
}

variable "launch_types" {
  type        = list(string)
  nullable    = false
  default     = []
  description = "ec2 | fargate"
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
  default  = [8080]
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
variable "logging_defaults" {
  nullable = false
  type = object({
    group  = string
    prefix = optional(string),
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

/*
 * list(object)
 * name = string
 * type = string
 *  bind_mount -> host_path=string
 *  docker     -> scope=string[task|shared], autoprovision=bool, driver=string[local], driver_opts=map(string), labels=map(string)
 *  efs        -> id=string, root_directory=string, encrypt=bool, transit_port=number, access_point_id=string, enable_iam=bool
 */
/*
variable volumes {
  type    = any
  default = []
}
*/

variable "volumes" {
  type = list(object({
    name = string
    type = string # bind_mount | "docker" | "efs"
    bind_mount = optional(object({
      host_path = string
    }))
    docker = optional(object({
      scope         = string # task | shared
      autoprovision = bool
      driver        = string # local
      driver_opts   = map(string)
      labels        = map(string)
    }))
    efs = optional(object({
      id              = string
      root_directory  = string
      encrypt         = bool
      transit_port    = number
      access_point_id = string
      enable_iam      = bool
    }))
  }))
}



/*
 * list(object)
 * volume         = string
 * container_path = string
 * read_only      = bool
 */
variable "mount_points" {
  type    = any
  default = []
}

# sizing
variable "sizing_defaults" {
  type = object({
    task      = object({ cpu = number, memory = number })
    container = object({ cpu = number, memory = number, memory-reservation = number })
  })
  default = {
    task      = { cpu = null, memory = null }
    container = { cpu = null, memory = null, memory-reservation = null }
  }
}

variable "sizing" {
  type    = map(map(number))
  default = {}
}