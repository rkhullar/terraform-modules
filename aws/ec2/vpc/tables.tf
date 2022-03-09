resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.default.default_route_table_id
  tags                   = merge(var.tags, { Name = "default" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { Name = "public" })
}

resource "aws_route_table" "private" {
  count  = var.zone_count
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { Name = "private-${local.number_to_letter[count.index]}" })
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.default.id
  tags   = merge(var.tags, { Name = "data" })
}

resource "aws_route_table_association" "public" {
  count          = var.zone_count
  route_table_id = aws_route_table.public.id
  subnet_id      = local.subnet_ids["public"][count.index]
}

resource "aws_route_table_association" "private" {
  count          = var.zone_count
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = local.subnet_ids["private"][count.index]
}

resource "aws_route_table_association" "data" {
  count          = var.zone_count
  route_table_id = aws_route_table.data.id
  subnet_id      = local.subnet_ids["data"][count.index]
}