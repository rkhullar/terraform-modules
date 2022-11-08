data "aws_vpc" "default" {
  tags = {
    Name = var.name
  }
}

data "aws_subnets" "default" {
  for_each = var.subnet_groups
  filter {
    name   = "vpc-id"
    values = [local.id]
  }
  filter {
    name   = "tag:Name"
    values = [local.subnet_regex[each.key]]
  }
}

locals {
  id      = data.aws_vpc.default.id
  cidr    = data.aws_vpc.default.cidr_block
  subnets = { for group in var.subnet_groups : group => data.aws_subnets.default[group].ids }
}