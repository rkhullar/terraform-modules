module "load-balancer" {
  source      = "../security-group"
  name        = local.names.load_balancer
  description = local.descriptions.load_balancer
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  ingress = {
    enable      = false
    protocol    = "tcp"
    ports       = local.rules.load_balancer.ingress.ports
    port_ranges = local.rules.load_balancer.ingress.port_ranges
    sources     = local.rules.load_balancer.ingress.sources
  }
}