variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "principals" {
  type    = list(object({ type = string, identifiers = list(string) }))
  default = []
}

variable "trust" {
  type    = string
  default = null
}

variable "policies" {
  type        = map(string)
  description = "key -> policy arn"
  default     = {}
}

variable "managed_policies" {
  type        = set(string)
  description = "aws managed policy names"
  default     = []
}

variable "inline_policies" {
  type        = map(string)
  description = "key -> policy json"
  default     = {}
}

variable "instance_profile" {
  type    = bool
  default = false
}

output "output" {
  value = aws_iam_role.default
}

output "profile" {
  value = var.instance_profile ? aws_iam_instance_profile.default[0] : null
}