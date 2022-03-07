locals {
  flags             = merge(var.flags_default, var.flags)
  enable_single_nat = local.flags["enable_nat"] && local.flags["single_nat"]
  enable_multi_nat  = local.flags["enable_nat"] && !local.flags["single_nat"]
  subnet_prefix     = merge(var.subnet_prefix_defaults, var.subnet_prefix)
  number_to_letter  = split("", "abcdefg")
  region            = data.aws_region.default.name
}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr
  tags                 = merge(var.tags, { Name = var.name })
  enable_dns_support   = local.flags["enable_dns_support"]
  enable_dns_hostnames = local.flags["enable_dns_hostnames"]
}

data "aws_region" "default" {}
