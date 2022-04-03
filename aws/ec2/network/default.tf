terraform {
  experiments = [module_variable_optional_attrs]
}

module "security-groups" {
  for_each    = local.rules
  source      = "../security-group"
  name        = local.names[each.key]
  description = local.descriptions[each.key]
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = var.aliases

  ingress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].ingress.ports
    port_ranges = local.rules[each.key].ingress.port_ranges
    sources     = local.rules[each.key].ingress.sources
  }

  egress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules[each.key].egress.ports
    port_ranges = local.rules[each.key].egress.port_ranges
    targets     = local.rules[each.key].egress.targets
  }
}

module "custom-rules" {
  source  = "../security-group/custom-rules"
  enable  = var.enable_rules
  aliases = var.aliases
  rules   = var.custom_rules
}

/*
data "aws_security_group" "default" {
  for_each = local.names
  name     = each.value
  vpc_id   = var.vpc_id
}
*/

data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = values(local.names)
  }
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

locals {
  aliases         = merge(local.security_groups, var.aliases)
  security_groups = zipmap(keys(module.security-groups), values(module.security-groups)[*].id)
}

output "debug" {
  value = data.aws_security_groups.default
}