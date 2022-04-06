locals {
  num = "\\d+"
  dot = "\\."
  hex = "[[:xdigit:]]"
}

locals {
  num_list_4     = [for i in range(4) : local.num]
  ipv4_address   = join(local.dot, local.num_list_4)
  ipv4_cidr      = "${local.ipv4_address}/${local.num}"
  sg_id_internal = "sg-${local.hex}+"
  sg_id_external = "${local.num}/${local.sg_id_internal}"
  sg_id          = "${local.sg_id_internal}|${local.sg_id_external}"
  plist_id       = "pl-${local.hex}+"
}

locals {
  regex_map = {
    cidr_block     = local.ipv4_cidr
    security_group = local.sg_id
    prefix_list    = local.plist_id
    self           = "self"
    # TODO: add regex for ipv6; type = cidr_block_v6
  }
}