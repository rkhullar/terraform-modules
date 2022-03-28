module "load-balancer" {
  source      = "../security-group"
  name        = local.names.load_balancer
  description = local.descriptions.load_balancer
  tags        = var.tags
  vpc_id      = var.vpc_id
  aliases     = local.aliases

  #  ingress = {
  #    enable      = false
  #    protocol    = "tcp"
  #    ports       = var.rules["load_balancer"].ports
  #    port_ranges = var.rules["load_balancer"].port_ranges
  #    sources     = var.rules["load_balancer"].sources
  #  }
}

output "debug-lb" {
  value = var.rules["load_balancer"].ingress.ports
}