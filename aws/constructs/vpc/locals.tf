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

locals {
  prefix = var.project
  suffix = "${var.environment}-${var.namespace}"
}

locals {
  default_name = "${local.prefix}-${var.name}-${local.suffix}"
  name         = coalesce(var.full_name, local.default_name)
}