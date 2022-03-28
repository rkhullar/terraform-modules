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
    sources     = local.load_balancer_ingress_sources
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
  load_balancer_ingress_sources = distinct(concat(
    local.rules.load_balancer.ingress.sources, local.rules.linux_runtime.ingress.sources
  ))
}