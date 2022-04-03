variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "policies" {
  type    = map(string)
  default = {}
}

variable "managed_policies" {
  type    = set(string)
  default = []
}

variable "inline_policies" {
  type    = map(string)
  default = {}
}

output "output" {
  value = aws_iam_user.default
}