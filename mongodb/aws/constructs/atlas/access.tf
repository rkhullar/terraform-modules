module "access" {
  depends_on      = [mongodbatlas_serverless_instance.serverless, mongodbatlas_advanced_cluster.advanced]
  source          = "../../atlas/access"
  project         = var.atlas_project
  cluster         = var.atlas_cluster
  create_admin    = var.flags.create_admin
  access_rules    = var.access_rules
  ingress_sources = var.ingress_sources
}