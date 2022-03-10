variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet" {
  type = string
}

output "debug" {
  value = {
    eip = aws_eip.default
    ngw = aws_nat_gateway.default
  }
}