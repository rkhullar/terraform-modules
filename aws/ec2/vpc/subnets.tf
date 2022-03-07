locals {
  groups        = ["public", "private", "data"]
  group_to_cidr = { for idx, group in local.groups : group => cidrsubnet(var.cidr, 2, idx) }
  subnet_bits   = max(2, ceil(log(var.zone_count, 2)))
  group_zone_to_cidr = { for group, group_cidr in local.group_to_cidr : group => [
    for idx in range(var.zone_count) : cidrsubnet(group_cidr, local.subnet_bits, idx)
  ] }
}

locals {
  subnet_detail_list = flatten([
    for group in local.groups : [
      for zone_idx in range(var.zone_count) : {
        group       = group
        zone_idx    = zone_idx
        zone_letter = local.number_to_letter[zone_idx]
        cidr_block  = local.group_zone_to_cidr[group][zone_idx]
  }]])
}

locals {
  subnet_detail_map = { for item in local.subnet_detail_list : join("/", [item.group, item.zone_idx]) => item }
}

resource "aws_subnet" "default" {
  for_each                = local.subnet_detail_map
  vpc_id                  = aws_vpc.default.id
  cidr_block              = each.value.cidr_block
  availability_zone       = "${local.region}${each.value.zone_letter}"
  map_public_ip_on_launch = each.value.group == "public" ? local.flags["map_public_ip_on_launch"] : false
  tags                    = merge(var.tags, { Name = "${local.subnet_prefix[each.value.group]}${each.value.zone_letter}" })
}