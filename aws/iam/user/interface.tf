variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
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

output "output" {
  value = aws_iam_user.default
}