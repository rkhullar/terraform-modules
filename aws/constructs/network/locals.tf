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
  base_names = defaults(var.names, {
    load_balancer = "load-balancer"
    linux_runtime = "linux-runtime"
    data_runtime  = "data-runtime"
  })
}

locals {
  security_group_names = { for key, val in local.base_names : key => "${local.prefix}-${val}-${local.suffix}" }
}