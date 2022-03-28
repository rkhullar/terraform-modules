terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  names = defaults(var.names, {
    load_balancer = "load-balancer"
    linux_runtime = "linux-runtime"
    data_runtime  = "data-runtime"
  })
  descriptions = defaults(var.descriptions, {
    load_balancer = "security group for load balancer"
    linux_runtime = "security group for linux runtime"
    data_runtime  = "security group for data runtime"
  })
}

locals {
  aliases = merge(local.default_aliases, var.aliases)
  default_aliases = {
    load_balancer = module.load-balancer.id
    linux_runtime = module.linux-runtime.id
    data_runtime  = module.data-runtime.id
  }
}

locals {
  # preprocess rules
  rules_with_keys = { for key in keys(local.names) : key => lookup(var.rules, key, null) }
  rules_2         = { for key, rule in local.rules_with_keys : key => rule }
}

output "debug-rules" {
  value = local.rules_2
}