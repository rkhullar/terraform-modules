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