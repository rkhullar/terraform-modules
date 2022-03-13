variable "peering_requests" {
  # TODO: try to make owner and region optional
  type    = list(object({ id = string, name = string, owner = string, region = string }))
  default = []
}
variable "peering_accepts" {
  type    = list(object({ id = string, name = string }))
  default = []
}

resource "aws_vpc_peering_connection" "default" {
  for_each      = { for item in var.peering_requests : item["id"] => item }
  vpc_id        = aws_vpc.default.id
  peer_vpc_id   = each.value["id"]
  peer_owner_id = coalesce(each.value["owner"], local.account_id)
  peer_region   = coalesce(each.value["region"], local.region)
  auto_accept   = false
  tags          = merge(var.tags, { Name = each.value["name"], side = "requester" })
}

resource "aws_vpc_peering_connection_accepter" "default" {
  for_each                  = { for item in var.peering_accepts : item["id"] => item }
  vpc_peering_connection_id = each.value["id"]
  auto_accept               = true
  tags                      = merge(var.tags, { Name = each.value["name"], side = "accepter" })
}