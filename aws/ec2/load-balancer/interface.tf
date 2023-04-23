variable "name" {
  type     = string
  nullable = false
}

variable "type" {
  type     = string
  nullable = false
  default  = "application"
  validation {
    condition     = contains(["application", "network"], var.type)
    error_message = "Allowed Values: {application | network}."
  }
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

# network
variable "vpc_id" {
  type     = string
  nullable = false
}

variable "internal" {
  type     = bool
  nullable = false
}

variable "subnets" {
  type     = list(string)
  nullable = false
}

variable "security_groups" {
  type     = list(string)
  nullable = false
}

# logs
variable "access_logs" {
  type = object({
    enabled = optional(bool, true)
    bucket  = string
    prefix  = optional(string)
  })
  nullable = true
  default  = null
}

variable "target_groups" {
  type    = any
  default = []
}

variable "listeners" {
  type    = any
  default = []
}

# misc
variable "idle_timeout" {
  type    = number
  default = 60
}

variable "default_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}
output "output" {
  value = aws_lb.default
}

# output
output "target_groups" {
  value = aws_lb_target_group.default
}

output "listeners" {
  value = aws_lb_listener.default
}

output "resource_labels" {
  value = { for name, group in aws_lb_target_group.default : name => "${aws_lb.default.arn_suffix}/${group["arn_suffix"]}" }
}