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

locals {
  # enumerate over sources and regexes
  source_regex = setproduct(keys(local.sources), keys(local.regex_map))
  source_regex_list = [for item in local.source_regex : {
    source_key = item[0]
    source_val = local.sources[item[0]]
    regex_key  = item[1]
    regex_val  = local.regex_map[item[1]]
  }]
  # filter to determine source types
  source_type_list = [for item in local.source_regex_list : item if can(regex("^${item.regex_val}$", item.source_val))]
  # source_type_list = [for item in local.source_regex_list : item if length(regexall("^${item.regex_val}$", item.source_val)) > 0]
}