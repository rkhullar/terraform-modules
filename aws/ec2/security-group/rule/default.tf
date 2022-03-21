resource "aws_security_group" "default" {
  # TODO: add enable flag?
  for_each                 = local.detail_map
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