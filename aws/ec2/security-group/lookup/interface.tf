variable "names" {
  type = map(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

output "output" {
  value = local.security_groups
}

output "status" {
  value = local.status
}