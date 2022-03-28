module "load-balancer" {
  source      = "../security-group"
  name        = local.names.load_balancer
  description = local.descriptions.load_balancer
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.load_balancer.ingress.ports
    port_ranges = local.rules.load_balancer.ingress.port_ranges
    sources     = local.load_balancer_sources
  }

  egress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.load_balancer.egress.ports
    port_ranges = local.rules.load_balancer.egress.port_ranges
    targets     = local.rules.load_balancer.egress.targets
  }
}

locals {
  extra_load_balancer_sources = local.enable_implicit_rules ? local.rules.linux_runtime.ingress.sources : []
  load_balancer_sources = distinct(concat(
    local.rules.load_balancer.ingress.sources, local.extra_load_balancer_sources
  ))
}

module "load-balancer-egress-linux-runtime" {
  source      = "../security-group/rule"
  enable      = local.enable_implicit_rules
  id          = module.load-balancer.id
  type        = "egress"
  ports       = local.rules.linux_runtime.ingress.ports
  port_ranges = local.rules.linux_runtime.ingress.port_ranges
  sources     = ["linux_runtime"]
  aliases     = local.default_aliases
}