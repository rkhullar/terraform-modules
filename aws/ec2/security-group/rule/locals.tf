locals {
  # split ordinary and aliased sources
  alias_keys      = keys(var.aliases)
  default_sources = [for item in var.sources : item if !contains(local.alias_keys, item)]
  alias_sources   = [for item in var.sources : item if contains(local.alias_keys, item)]
  # combine into map of source keys and values
  sources = merge(
    { for item in local.default_sources : item => item },
    { for item in local.alias_sources : item => var.aliases[item] }
  )
}