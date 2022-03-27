locals {
  # combine raw values for sources and targets
  raw_sources   = [for rule in var.rules : rule.source]
  raw_targets   = [for rule in var.rules : rule.target]
  raw_locations = distinct(concat(local.raw_sources, local.raw_targets))
  # split ordinary and alias locations
  alias_keys        = keys(var.aliases)
  default_locations = [for item in local.raw_locations : item if !contains(local.alias_keys, item)]
  alias_locations   = [for item in local.raw_locations : item if contains(local.alias_keys, item)]
  # combine into map of location keys and values
  locations = merge(
    { for item in local.default_locations : item => item },
    { for item in local.alias_locations : item => var.aliases[item] }
  )
}

locals {
  # enumerate over locations and regexes
  location_regex = setproduct(keys(local.locations), keys(local.regex_map))
  location_regex_list = [for item in local.location_regex : {
    location_key = item[0]
    location_val = local.locations[item[0]]
    regex_key    = item[1]
    regex_val    = local.regex_map[item[1]]
  }]
  # filter to determine source types
  location_type_list = [for item in local.location_regex_list : item if can(regex("^${item.regex_val}$", item.location_val))]
  location_type_map  = { for item in local.location_type_list : item.location_key => item }
}

locals {
  # filter rules by regex matched sources and targets
  matched_locations       = keys(local.location_type_map)
  location_verified_rules = [for rule in var.rules : rule if contains(local.matched_locations, rule.source) && contains(local.matched_locations, rule.target)]
  # add context for source and target types
  rules_with_type = [for rule in local.location_verified_rules : merge(rule, {
    source_type = local.location_type_map[rule.source]
    target_type = local.location_type_map[rule.target]
  })]
}

output "debug" {
  value = local.rules_with_type
}