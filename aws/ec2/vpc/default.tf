locals {
  flags             = merge(var.flags_default, var.flags)
  enable_single_nat = local.flags["enable_nat"] && local.flags["single_nat"]
  enable_multi_nat  = local.flags["enable_nat"] && !local.flags["single_nat"]
}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr
  tags                 = merge(var.tags, { Name = var.name })
  enable_dns_support   = local.flags["enable_dns_support"]
  enable_dns_hostnames = local.flags.enable_dns_hostnames
}

