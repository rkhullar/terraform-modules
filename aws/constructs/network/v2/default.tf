module "default" {
  source       = "../../../ec2/network/v2"
  vpc_id       = local.vpc.id
  tags         = local.common_tags
  prefix       = local.prefix
  suffix       = local.suffix
  names        = var.names
  descriptions = var.descriptions
  aliases      = var.aliases
  enable_rules = var.enable_rules
  rules        = var.rules
  custom_rules = var.custom_rules
}