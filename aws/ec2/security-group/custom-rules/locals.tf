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