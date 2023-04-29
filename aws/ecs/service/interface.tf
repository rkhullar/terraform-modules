variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "cluster" {
  type     = string
  nullable = false
}

variable "launch_type" {
  type     = string
  nullable = true
  validation {
    condition     = contains(["ec2", "fargate"], var.launch_type)
    error_message = "Allowed Values: {ec2 | fargate}."
  }
}

variable "capacity_providers" {
  default  = []
  nullable = false
  type = list(object({
    name   = string
    weight = number
    base   = optional(number)
  }))
}

variable "iam_role" {
  type        = string
  nullable    = true
  default     = null
  description = "required if using load balancer without awsvpc network mode"
}

variable "force_new_deployment" {
  type    = bool
  default = true
}

# network
variable "subnets" {
  type     = list(string)
  nullable = false
}

variable "security_groups" {
  type     = list(string)
  nullable = false
}

variable "target_group" {
  type     = string
  nullable = true
  default  = null
}

variable "skip_default" {
  type     = bool
  nullable = false
  default  = false
}

variable "platform_version" {
  type     = string
  nullable = false
  default  = "latest"
}

/*
 * list(object)
 * target_group_arn = string
 * container_name   = number
 * container_port   = number
 */
variable "load_balancer" {
  type    = any
  default = []
}

# default task
variable "python_version" {
  type     = string
  nullable = false
  default  = "3.10"
}

# tagging
variable "propagate_tags" {
  type     = string
  nullable = false
  default  = "service"
  validation {
    condition     = contains(["service", "task-definition"], var.propagate_tags)
    error_message = "Allowed Values: {service | task-definition}."
  }
}

variable "enable_ecs_managed_tags" {
  type     = bool
  nullable = false
  default  = true
}

variable "enable_execute_command" {
  type     = bool
  nullable = false
  default  = false
}

# task
variable "task_config" {
  type     = any
  nullable = false
}

# autoscaling
variable "capacity" {
  type     = map(number)
  nullable = false
  default  = {}
}

variable "autoscaling" {
  type     = any
  nullable = false
  default  = {}
}

# output
output "default" {
  value = aws_ecs_service.default
}

output "docker-repo" {
  value = one(aws_ecr_repository.default[*].name)
}

output "task-def" {
  value = {
    default = module.default-task-def.default
    target  = module.target-task-def.default
  }
}