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

variable "architecture" {
  type     = string
  nullable = true
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "Allowed Values: {x86_64 | arm64}."
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

variable "platform_version" {
  type     = string
  nullable = false
  default  = "latest"
}

variable "load_balancer" {
  default  = []
  nullable = false
  type = list(object({
    target_group_arn = string
    container_name   = optional(number)
    container_port   = optional(number)
  }))
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

# flags
variable "flags" {
  default  = {}
  nullable = false
  type = object({
    force_new_deployment    = optional(bool, true)
    enable_ecs_managed_tags = optional(bool, true)
    enable_execute_command  = optional(bool, false)
    skip_default            = optional(bool, false)
  })
}

# autoscaling
variable "capacity" {
  default  = {}
  nullable = false
  type = object({
    desired = optional(number, 1)
    min     = optional(number)
    max     = optional(number)
  })
}

variable "autoscaling" {
  type     = any
  nullable = false
  default  = {}
}

# task
variable "task_config" {
  type     = any
  nullable = false
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