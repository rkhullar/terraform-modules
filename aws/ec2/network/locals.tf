locals {
  names = defaults(var.names, {
    load_balancer = "load-balancer"
    linux_runtime = "linux-runtime"
    data_runtime  = "data-runtime"
  })
}

locals {
  descriptions = defaults(var.descriptions, {
    load_balancer = "security group for load balancer"
    linux_runtime = "security group for linux runtime"
    data_runtime  = "security group for data runtime"
  })
}

locals {
  aliases         = merge(local.default_aliases, var.aliases)
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
  default_aliases = {}
  #  default_aliases = {
  #    load_balancer = lookup(local.security_groups, "load-balancer", null)
  #    linux_runtime = lookup(local.security_groups, "linux-runtime", null)
  #    data_runtime  = lookup(local.security_groups, "data-runtime", null)
  #  }
}

locals {
  # preprocess rules to remove undefined or null values
  rules_with_keys = { for key in keys(local.names) : key => lookup(var.rules, key, null) }
  rules_with_type = { for key, rule in local.rules_with_keys : key => {
    for _type in ["ingress", "egress"] : _type => rule != null ? rule[_type] : null
  } }
  rules = { for key, rule in local.rules_with_type : key => {
    for _type, leaf in rule : _type => {
      for prop in ["ports", "port_ranges", "sources", "targets"] : prop => coalesce(try(leaf[prop], null), [])
  } } }
}