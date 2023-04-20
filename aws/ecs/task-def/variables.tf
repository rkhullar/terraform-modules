# task
variable family {
  type = string
}

variable tags {
  type    = map(string)
  default = {}
}

variable roles_default {
  type    = object({ task = string, exec = string })
  default = { task = null, exec = null }
  # exec role required when using container secrets
}

variable roles {
  type    = map(string)
  default = {}
}

variable network_mode {
  type        = string
  default     = "awsvpc"
  description = "none | bridge | task | host"
}

variable launch_types {
  type        = list(string)
  default     = []
  description = "ec2 | fargate"
}

# container
variable image {
  type = string
}

variable container {
  type    = string
  default = null
}

variable envs {
  type    = map(string)
  default = {}
}

variable secrets {
  type    = map(string)
  default = {}
}

variable ignore_case {
  type    = bool
  default = false
}

variable ports {
  type    = list(number)
  default = [8080]
}

variable entrypoint {
  type    = list(string)
  default = []
}

variable command {
  type    = list(string)
  default = []
}

# logging
variable logging_defaults {
  type    = object({ group = string, prefix = string, region = string })
  default = { group = null, prefix = null, region = null }
  # group required
}

variable logging {
  type    = map(string)
  default = {}
}

variable ulimits {
  type    = list(object({ name = string, hard-limit = number, soft-limit = number }))
  default = []
}

variable flags_default {
  type = object({
    enabled     = bool
    essential   = bool
    docker-init = bool
    privileged  = bool
  })
  default = {
    enabled     = true
    essential   = true
    docker-init = false
    privileged  = false
  }
}

variable flags {
  type    = map(bool)
  default = {}
}

/*
 * list(object)
 * name = string
 * type = string
 *  bind_mount -> host_path=string
 *  docker     -> scope=string[task|shared], autoprovision=bool, driver=string[local], driver_opts=map(string), labels=map(string)
 *  efs        -> id=string, root_directory=string, encrypt=bool, transit_port=number, access_point_id=string, enable_iam=bool
 */
variable volumes {
  type    = any
  default = []
}

/*
 * list(object)
 * volume         = string
 * container_path = string
 * read_only      = bool
 */
variable mount_points {
  type    = any
  default = []
}

# sizing
variable sizing_defaults {
  type = object({
    task      = object({ cpu = number, memory = number })
    container = object({ cpu = number, memory = number, memory-reservation = number })
  })
  default = {
    task      = { cpu = null, memory = null }
    container = { cpu = null, memory = null, memory-reservation = null }
  }
}

variable sizing {
  type    = map(map(number))
  default = {}
}