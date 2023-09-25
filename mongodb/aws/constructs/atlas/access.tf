module "access" {
  depends_on      = [mongodbatlas_serverless_instance.serverless, mongodbatlas_advanced_cluster.advanced]
  source          = "../../atlas/access"
  providers       = { mongodbatlas = mongodbatlas.default }
  project         = var.atlas_project
  cluster         = var.atlas_cluster
  create_admin    = var.flags.create_admin
  access_rules    = var.access_rules
  ingress_sources = var.ingress_sources
  role_prefix     = local.role_prefix
  role_suffix     = local.role_suffix
}

locals {
  default_role_prefix = "${var.project}-"
  default_role_suffix = "-${var.environment}-${var.namespace}"
  role_prefix         = var.flags.render_role ? coalesce(var.flags.role_prefix, local.default_role_prefix) : null
  role_suffix         = var.flags.render_role ? coalesce(var.flags.role_suffix, local.default_role_suffix) : null
}