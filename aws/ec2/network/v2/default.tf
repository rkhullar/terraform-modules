terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  names           = { for name in var.names : name => join("-", compact([var.prefix, name, var.suffix])) }
  descriptions    = { for name in var.names : name => lookup(var.descriptions, name, local.names[name]) }
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}

module "security-groups" {
  for_each    = var.names
  source      = "../../security-group"
  name        = local.names[each.key]
  description = local.descriptions[each.key]
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = local.enable_rules
    protocol    = try(var.rules[each.key].ingress.protocol, null)
    ports       = try(var.rules[each.key].ingress.ports, null)
    port_ranges = try(var.rules[each.key].ingress.port_ranges, null)
    sources     = try(var.rules[each.key].ingress.sources, null)
  }

  egress = {
    enable      = local.enable_rules
    protocol    = try(var.rules[each.key].egress.protocol, null)
    ports       = try(var.rules[each.key].egress.ports, null)
    port_ranges = try(var.rules[each.key].egress.port_ranges, null)
    targets     = try(var.rules[each.key].egress.targets, null)
  }
}

module "security-groups-lookup" {
  source = "../../security-group/lookup"
  names  = local.names
  vpc_id = var.vpc_id
}

module "rules" {
  source  = "../../security-group/custom-rules"
  enable  = local.enable_rules
  aliases = local.aliases
  rules   = var.custom_rules
}