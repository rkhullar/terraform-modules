locals {
  base_names   = toset([for data in var.security_groups : data.name])
  names        = { for data in var.security_groups : data.name => join("-", compact([var.prefix, data.name, var.suffix])) }
  descriptions = { for data in var.security_groups : data.name => defaults(data.description, local.names[data.name]) }
}

locals {
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}