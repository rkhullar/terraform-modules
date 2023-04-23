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
  security_group_names = { for key, val in var.names : key => "${local.prefix}-${val}-${local.suffix}" }
}