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
  aliases = merge(local.default_aliases, var.aliases)
  /*
  security_groups = values(module.security-groups)[*].id
  default_aliases = {
    load_balancer = local.security_groups["load-balancer"]
    linux_runtime = local.security_groups["linux-runtime"]
    data_runtime  = local.security_groups["data-runtime"]
  }
  */
  default_aliases = !var.enable_rules ? {} : {
    for key, doc in module.security-groups[*] : key => doc.id
  }
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