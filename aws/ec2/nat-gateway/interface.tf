variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet" {
  type = string
}

output "id" {
  value = aws_nat_gateway.default.id
}

output "ip" {
  value = aws_eip.default.public_ip
}