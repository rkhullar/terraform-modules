locals {
  names           = { for name in var.names : name => join("-", compact([var.prefix, name, var.suffix])) }
  descriptions    = { for name in var.names : name => lookup(var.descriptions, name, local.names[name]) }
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}