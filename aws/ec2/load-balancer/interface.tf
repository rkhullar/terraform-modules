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
  default  = null
  nullable = true
  type = object({
    enabled = optional(bool, true)
    bucket  = string
    prefix  = optional(string)
  })
}

variable "target_groups" {
  type    = any
  default = []
}

variable "listeners" {
  default  = []
  nullable = false
  type = list(object({
    port       = number
    protocol   = string
    cert       = optional(string)
    ssl_policy = optional(string)
    action     = string
    forward = optional(object({
      target_group = string
    }))
    redirect = optional(object({
      path        = optional(string)
      host        = optional(string)
      protocol    = optional(string)
      port        = optional(number)
      query       = optional(string)
      status_code = string
    }))
    fixed_response = optional(object({
      content_type = string
      message_body = optional(string)
      status_code  = optional(number)
    }))
  }))
  validation {
    condition     = length([for item in var.listeners : item if !contains(["tcp", "http", "https"], item["protocol"])]) == 0
    error_message = "Allowed Values: protocol -> {tcp | http | https}."
  }
  validation {
    condition     = length([for item in var.listeners : item if !contains(["forward", "redirect", "fixed-response", "authenticate-cognito", "authenticate-oidc"], item["action"])]) == 0
    error_message = "Allowed Values: action -> {forward | redirect | fixed-response | authenticate-cognito | authenticate-oidc}."
  }
}

# misc
variable "idle_timeout" {
  type     = number
  nullable = true
  default  = 60
}

variable "ssl_policy" {
  type     = string
  nullable = false
  default  = "ELBSecurityPolicy-2016-08"
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