locals {
  x = [for source in var.sources: try(regex(local.regex_map["cidr_block"], source))]
}