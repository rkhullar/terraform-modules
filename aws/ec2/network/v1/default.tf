module "security-groups" {
  for_each    = local.rules
  source      = "../../security-group"
  name        = var.names[each.key]
  description = var.descriptions[each.key]
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = local.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].ingress.ports
    port_ranges = local.rules[each.key].ingress.port_ranges
    sources     = local.rules[each.key].ingress.sources
  }

  egress = {
    enable      = local.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].egress.ports
    port_ranges = local.rules[each.key].egress.port_ranges
    targets     = local.rules[each.key].egress.targets
  }
}

module "security-groups-lookup" {
  source = "../../security-group/lookup"
  names  = var.names
  vpc_id = var.vpc_id
}

module "custom-rules" {
  source  = "../../security-group/custom-rules"
  enable  = local.enable_rules
  aliases = local.aliases
  rules   = var.custom_rules
}