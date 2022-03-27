resource "aws_security_group" "default" {
  vpc_id      = var.vpc_id
  name        = var.name
  name_prefix = var.name_prefix
  description = var.description
  tags        = var.tags
}

locals {
  ingress = merge(var.ingress_defaults, var.ingress)
  egress  = merge(var.egress_defaults, var.egress)
}

module "ingress-rules" {
  source      = "./rule"
  id          = aws_security_group.default.id
  type        = "ingress"
  enable      = local.ingress["enable"]
  protocol    = local.ingress["protocol"]
  ports       = local.ingress["ports"]
  port_ranges = local.ingress["port_ranges"]
  sources     = local.ingress["sources"]
  aliases     = var.aliases
}

module "egress-rules" {
  source      = "./rule"
  id          = aws_security_group.default.id
  type        = "egress"
  enable      = local.egress["enable"]
  protocol    = local.egress["protocol"]
  ports       = local.egress["ports"]
  port_ranges = local.egress["port_ranges"]
  sources     = local.egress["targets"]
  aliases     = var.aliases
}