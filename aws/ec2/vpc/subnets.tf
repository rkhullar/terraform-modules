locals {
  groups        = ["public", "private", "data"]
  group_to_cidr = { for idx, group in local.groups : group => cidrsubnet(var.cidr, 2, idx) }
  group_zone_to_cidr = { for group, group_cidr in local.group_to_cidr : group => [
    for idx in range(var.zone_count) : cidrsubnet(group_cidr, 2, idx)
  ] }
}

resource "aws_subnet" "public" {
  count                   = var.zone_count
  vpc_id                  = aws_vpc.default.id
  cidr_block              = local.group_zone_to_cidr["public"][count.index]
  availability_zone       = "${local.region}${local.number_to_letter[count.index]}"
  map_public_ip_on_launch = local.flags["map_public_ip_on_launch"]
  tags                    = merge(var.tags, { Name = "${local.subnet_prefix["public"]}${local.number_to_letter[count.index]}" })
}