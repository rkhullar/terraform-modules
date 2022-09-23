resource "aws_eip" "default" {
  vpc  = true
  tags = var.tags
}

resource "aws_nat_gateway" "default" {
  allocation_id = aws_eip.default.id
  subnet_id     = var.subnet
  tags          = var.tags
}