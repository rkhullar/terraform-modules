locals {
  names        = toset([for data in var.security_groups : data.name])
  descriptions = { for data in var.security_groups : data.name => defaults(data.description, data.name) }
}

locals {
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}