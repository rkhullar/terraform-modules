variable name {
  type = string
}

variable tags {
  type    = map(string)
  default = {}
}

variable cluster {
  type = string
}

variable launch_type {
  type        = string
  description = "ec2 | fargate"
}

variable iam_role {
  type        = string
  default     = null
  description = "required if using load balancer without awsvpc network mode"
}

variable force_new_deployment {
  type    = bool
  default = true
}

# network
variable subnets {
  type = list(string)
}

variable security_groups {
  type = list(string)
}

variable target_group {
  type    = string
  default = null
}

variable skip_default {
  type    = bool
  default = false
}

variable platform_version {
  type    = string
  default = "latest"
}

/*
 * list(object)
 * target_group_arn = string
 * container_name   = number
 * container_port   = number
 */
variable load_balancer {
  type    = any
  default = []
}

# default task
variable python_version {
  type    = string
  default = "3.7.9"
}

# tagging
variable propagate_tags {
  type        = string
  default     = "service"
  description = "service | task-definition"
}

variable enable_ecs_managed_tags {
  type    = bool
  default = true
}

# task
variable task_config {
  type = any
}

# autoscaling
variable capacity {
  type    = map(number)
  default = {}
}

variable autoscaling {
  type    = any
  default = {}
}

/*
 * list(object)
 * name   = string
 * weight = number
 * base   = number
 */
variable capacity_providers {
  type    = any
  default = []
}