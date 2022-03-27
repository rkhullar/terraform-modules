terraform {
  experiments = [module_variable_optional_attrs]
}

resource "aws_security_group_rule" "default" {
  for_each                 = var.enable ? local.detail_map : {}
  security_group_id        = each.value.group_id
  type                     = each.value.type
  protocol                 = each.value.protocol
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  cidr_blocks              = each.value.location_type == "cidr_block" ? [each.value.location] : null
  source_security_group_id = each.value.location_type == "security_group" ? each.value.location : null
  prefix_list_ids          = each.value.location_type == "prefix_list" ? [each.value.location] : null
  ipv6_cidr_blocks         = each.value.location_type == "cidr_block_v6" ? [each.value.location] : null
  self                     = each.value.location_type == "self" ? true : null
  description              = each.value.description
}