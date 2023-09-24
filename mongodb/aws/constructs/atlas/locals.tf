locals {
  common_tags = {
    account     = var.account
    project     = var.project
    owner       = var.owner
    namespace   = var.namespace
    environment = var.environment
    region      = var.region
    managed     = "terraform"
  }
}