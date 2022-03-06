module "default" {
  source = "../../ec2/vpc"
  name   = local.name
  tags   = local.common_tags
  cidr   = var.cidr
  flags  = var.flags
}