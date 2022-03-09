locals {
  flags             = merge(var.flags_default, var.flags)
  enable_single_nat = local.flags["enable_nat"] && local.flags["single_nat"]
  enable_multi_nat  = local.flags["enable_nat"] && !local.flags["single_nat"]
  subnet_prefix     = merge(var.subnet_prefix_defaults, var.subnet_prefix)
  number_to_letter  = split("", "abcdefg")
  region            = data.aws_region.default.name
  nat_zone          = coalesce(var.nat_zone, 0)
}

data "aws_region" "default" {}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr
  tags                 = merge(var.tags, { Name = var.name })
  enable_dns_support   = local.flags["enable_dns_support"]
  enable_dns_hostnames = local.flags["enable_dns_hostnames"]
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { Name = var.name })
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { Name = var.name })
}

resource "aws_eip" "multi" {
  count = local.enable_multi_nat ? var.zone_count : 0
  tags  = merge(var.tags, { Name = var.name })
}

resource "aws_eip" "single" {
  count = local.enable_single_nat ? 1 : 0
  tags  = merge(var.tags, { Name = var.name })
}

resource "aws_nat_gateway" "multi" {
  count         = local.enable_multi_nat ? var.zone_count : 0
  allocation_id = aws_eip.multi[count.index].id
  subnet_id     = local.subnet_ids["public"][count.index]
  tags          = merge(var.tags, { Name = var.name })
}

resource "aws_nat_gateway" "single" {
  count         = local.enable_single_nat ? 1 : 0
  allocation_id = aws_eip.single[0].id
  subnet_id     = local.subnet_ids["public"][local.nat_zone]
  tags          = merge(var.tags, { Name = var.name })
}