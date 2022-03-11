module "default" {
  source        = "../../ec2/vpc"
  name          = local.name
  tags          = local.common_tags
  cidr          = var.cidr
  zone_count    = var.zone_count
  flags         = var.flags
  nat_zone      = var.nat_zone
  subnet_prefix = var.subnet_prefix
}