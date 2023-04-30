variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  default  = {}
  nullable = false
}

variable "container_insights" {
  type     = bool
  default  = true
  nullable = false
}

variable "capacity_providers" {
  type = list(object({
    name   = string
    weight = optional(number)
    base   = optional(number)
  }))
  default  = []
  nullable = false
}

variable "enable_default_strategy" {
  type     = bool
  default  = true
  nullable = false
}

output "output" {
  value = aws_ecs_cluster.default
}