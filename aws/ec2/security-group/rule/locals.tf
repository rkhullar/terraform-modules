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
  source_type_map  = { for item in local.source_type_list : item.source_key => item }
}

locals {
  # process port ranges
  _port_ranges_from_number = [for port in var.ports : [port, port]]
  _port_ranges_from_string = [for text in var.port_ranges : [for val in split("-", text) : tonumber(val)]]
  _port_ranges             = concat(local._port_ranges_from_number, local._port_ranges_from_string)
  enable_all_traffic       = contains(["all", "-1"], var.protocol)
  port_ranges              = local.enable_all_traffic ? [[0, 0]] : local._port_ranges
}

locals {
  # generate resource details
  source_port_ranges      = setproduct(keys(local.source_type_map), local.port_ranges)
  source_port_ranges_list = [for pair in local.source_port_ranges : zipmap(["source_key", "port_range"], pair)]
  detail_list = [for item in local.source_port_ranges_list : {
    source_key = item.source_key
    source_val = local.source_type_map[item.source_key].source_val
    regex_key  = local.source_type_map[item.source_key].regex_key
    port_range = item.port_range
  }]
  detail_map = { for item in local.detail_list : "${item.source_key}.${join("-", distinct(item.port_range))}" => item }
}