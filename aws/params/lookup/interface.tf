variable "project" {
  type     = string
  nullable = false
}

variable "environment" {
  type     = string
  nullable = false
}

variable "names" {
  type     = set(string)
  nullable = false
}

output "values" {
  value = local.values
}