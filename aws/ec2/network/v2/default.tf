terraform {
  experiments = [module_variable_optional_attrs]
}

module "security-groups" {
  for_each    = local.base_names
  source      = "../../security-group"
  name        = local.names[each.key]
  description = local.descriptions[each.key]
  tags        = var.tags
  vpc_id      = var.vpc_id
}

module "security-groups-lookup" {
  source = "../../security-group/lookup"
  names  = local.names
  vpc_id = var.vpc_id
}

module "rules" {
  source  = "../../security-group/custom-rules"
  enable  = local.enable_rules
  aliases = local.aliases
  rules   = var.rules
}