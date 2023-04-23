module "default" {
  source           = "../../../ec2/network/v1"
  vpc_id           = local.vpc.id
  tags             = local.common_tags
  names            = local.security_group_names
  descriptions     = var.descriptions
  rules            = var.rules
  aliases          = var.aliases
  enable_rules     = var.enable_rules
  ingress_protocol = var.ingress_protocol
  egress_protocol  = var.egress_protocol
  custom_rules     = var.custom_rules
}