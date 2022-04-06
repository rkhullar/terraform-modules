module "default" {
  source           = "../../ec2/vpc"
  name             = local.name
  tags             = local.common_tags
  cidr             = var.cidr
  zone_count       = var.zone_count
  flags            = var.flags
  nat_zone         = var.nat_zone
  subnet_prefix    = var.subnet_prefix
  peering_requests = local.peering_requests
  peering_accepts  = local.peering_accepts
  routes           = local.common_routes
  public_routes    = local.public_routes
  private_routes   = local.private_routes
  data_routes      = local.data_routes
}