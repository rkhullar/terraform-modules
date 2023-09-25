variable "template" {
  type = string
  nullable = false
}

variable "params" {
  type = map(string)
  nullable = false
}

output "rendered" {
  value = local.rendered
}

output "params" {
  value = var.params
}