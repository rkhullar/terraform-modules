variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnet" {
  type = string
}

variable "debug" {
  eip = aws_eip.default
  ngw = aws_nat_gateway.default
}