module "data-runtime" {
  source      = "../security-group"
  name        = local.names.data_runtime
  description = local.descriptions.data_runtime
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.data_runtime.ingress.ports
    port_ranges = local.rules.data_runtime.ingress.port_ranges
    sources     = local.rules.data_runtime.ingress.sources
  }

  egress = {
    enable      = var.enable_rules
    protocol    = var.egress_protocol
    ports       = local.rules.data_runtime.egress.ports
    port_ranges = local.rules.data_runtime.egress.port_ranges
    targets     = local.rules.data_runtime.egress.targets
  }
}