variable name {
  type = string
}

variable tags {
  type    = map(string)
  default = {}
}

variable container_insights {
  type    = bool
  default = true
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

variable enable_default_strategy {
  type    = bool
  default = true
}

output output {
  value = aws_ecs_cluster.default
}