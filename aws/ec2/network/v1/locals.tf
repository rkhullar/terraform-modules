locals {
  aliases         = merge(module.security-groups-lookup.output, var.aliases)
  enable_rules    = var.enable_rules && module.security-groups-lookup.status
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}

locals {
  # preprocess rules to remove undefined or null values
  rules_with_keys = { for key in keys(var.names) : key => lookup(var.rules, key, null) }
  rules_with_type = { for key, rule in local.rules_with_keys : key => {
    for _type in ["ingress", "egress"] : _type => rule != null ? rule[_type] : null
  } }
  rules = { for key, rule in local.rules_with_type : key => {
    for _type, leaf in rule : _type => {
      for prop in ["ports", "port_ranges", "sources", "targets"] : prop => coalesce(try(leaf[prop], null), [])
  } } }
}