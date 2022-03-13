resource "aws_route" "public-igw" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.default.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private-multi-nat" {
  count                  = local.enable_multi_nat ? var.zone_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = module.multi-nat-gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private-single-nat" {
  count                  = local.enable_single_nat ? var.zone_count : 0
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = module.single-nat-gateway[0].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "custom" {
  for_each                  = local.custom_route_detail_map
  route_table_id            = each.value["table_id"]
  destination_cidr_block    = each.value["destination"]
  gateway_id                = contains(["igw", "vgw"], each.value["type"]) ? each.value["target"] : null
  vpc_peering_connection_id = each.value["type"] == "pcx" ? each.value["target"] : null
}

locals {
  # combine general and subnet class routes
  public_routes  = concat(var.routes, var.public_routes)
  private_routes = concat(var.routes, var.private_routes)
  data_routes    = concat(var.routes, var.data_routes)
  # associate route tables with routes
  public_table_routes  = setproduct([aws_route_table.public.id], local.public_routes)
  private_table_routes = setproduct(aws_route_table.private.*.id, local.private_routes)
  data_table_routes    = setproduct([aws_route_table.data.id], local.data_routes)
  # generate resource details
  custom_routes = concat(local.public_table_routes, local.private_table_routes, local.data_table_routes)
  custom_route_detail_list = [for item in local.custom_routes : {
    table_id    = pair[0]
    destination = pair[1]["destination"]
    target      = pair[1]["target"]
    type        = split("-", pair[1]["target"])[0]
  }]
  custom_route_detail_map = { for item in local.custom_route_detail_list : "${item.table_id}_${item.destination}" => item }
}