/*
resource "aws_security_group" "default" {
  for_each                 = var.enable ? local.detail_map : {}
  security_group_id        = var.id
  type                     = var.type
  protocol                 = var.protocol
  from_port                = each.value.port_range[0]
  to_port                  = each.value.port_range[1]
  cidr_blocks              = each.value.regex_key == "cidr_block" ? [each.value.source_val] : null
  source_security_group_id = each.value.regex_key == "security_group" ? each.value.source_val : null
  prefix_list_ids          = each.value.regex_key == "prefix_list" ? [each.value.source_val] : null
  ipv6_cidr_blocks         = each.value.regex_key == "cidr_block_v6" ? [each.value.source_val] : null
  self                     = each.value.regex_key == "self" ? true : null
}
*/

locals {
  mock = { for key, item in local.detail_map : key => {
    security_group_id        = var.id
    type                     = var.type
    protocol                 = var.protocol
    from_port                = item.port_range[0]
    to_port                  = item.port_range[1]
    cidr_blocks              = item.regex_key == "cidr_block" ? [item.source_val] : null
    source_security_group_id = item.regex_key == "security_group" ? item.source_val : null
    prefix_list_ids          = item.regex_key == "prefix_list" ? [item.source_val] : null
    ipv6_cidr_blocks         = item.regex_key == "cidr_block_v6" ? [item.source_val] : null
    self                     = item.regex_key == "self" ? true : null
  } }
}