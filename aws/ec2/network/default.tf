terraform {
  experiments = [module_variable_optional_attrs]
}

module "security-groups" {
  for_each    = local.rules
  source      = "../security-group"
  name        = local.names[each.key]
  description = local.descriptions[each.key]
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = local.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].ingress.ports
    port_ranges = local.rules[each.key].ingress.port_ranges
    sources     = local.rules[each.key].ingress.sources
  }

  egress = {
    enable      = local.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].egress.ports
    port_ranges = local.rules[each.key].egress.port_ranges
    targets     = local.rules[each.key].egress.targets
  }
}

module "custom-rules" {
  source  = "../security-group/custom-rules"
  enable  = local.enable_rules
  aliases = local.aliases
  rules   = var.custom_rules
}

data "aws_security_groups" "default" {
  for_each = local.names
  filter {
    name   = "group-name"
    values = [each.value]
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  aliases               = merge(local.default_aliases, var.aliases)
  security_groups       = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
  security_group_lookup = zipmap(keys(data.aws_security_groups.default), values(data.aws_security_groups.default)[*].ids)
  default_aliases       = { for key, arr in local.security_group_lookup : key => arr[0] if length(arr) > 0 }
  default_enable_rules  = length(keys(var.names)) == length(keys(local.default_aliases))
  enable_rules          = var.enable_rules && local.default_enable_rules
}