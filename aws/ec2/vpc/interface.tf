variable "cidr" {
  type = string
}

output "debug" {
  value = var.cidr
}