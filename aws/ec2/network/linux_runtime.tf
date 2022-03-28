module "linux-runtime" {
  source      = "../security-group"
  name        = local.names.linux_runtime
  description = local.descriptions.linux_runtime
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.linux_runtime.ingress.ports
    port_ranges = local.rules.linux_runtime.ingress.port_ranges
    sources     = local.rules.linux_runtime.ingress.sources
  }

  egress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.linux_runtime.egress.ports
    port_ranges = local.rules.linux_runtime.egress.port_ranges
    targets     = local.rules.linux_runtime.egress.targets
  }
}

module "linux-runtime-ingress-load-balancer" {
  source      = "../security-group/rule"
  enable      = local.enable_implicit_rules
  id          = module.linux-runtime.id
  type        = "ingress"
  ports       = local.rules.linux_runtime.ingress.ports
  port_ranges = local.rules.linux_runtime.ingress.port_ranges
  sources     = ["load_balancer"]
  aliases     = local.default_aliases
}

module "linux-runtime-egress-data-runtime" {
  source      = "../security-group/rule"
  enable      = local.enable_implicit_rules
  id          = module.linux-runtime.id
  type        = "egress"
  ports       = local.rules.data_runtime.ingress.ports
  port_ranges = local.rules.data_runtime.ingress.port_ranges
  sources     = ["data_runtime"]
  aliases     = local.default_aliases
}