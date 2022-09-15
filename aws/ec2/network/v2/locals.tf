locals {
  names           = { for name in var.names : name => join("-", compact([var.prefix, name, var.suffix])) }
  descriptions    = { for name in var.names : name => lookup(var.descriptions, name, local.names[name]) }
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}

locals {
  # preprocess rules to remove undefined or null values
  rules_with_name = { for name in var.names : name => lookup(var.rules, name, null) }
  rules_with_type = { for name, object in local.rules_with_name : name => {
    for _type in ["ingress", "egress"] : _type => object != null ? object[_type] : null
  } }
  rules = { for name, object in local.rules_with_type : name => {
    for _type, leaf in object : _type => {
      protocol    = lookup(leaf, "protocol", var.default_protocol)
      ports       = lookup(leaf, "ports", null)
      port_ranges = lookup(leaf, "port_ranges", null)
      sources     = lookup(leaf, "sources", null)
      targets     = lookup(leaf, "targets", null)
  } } }
}