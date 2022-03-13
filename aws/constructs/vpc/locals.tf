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

locals {
  peering = merge(var.peering_defaults, var.peering)
  peering_requests = [for item in local.peering["requests"] : {
    id = item["id"], name = item["name"], owner = lookup(item, "owner", null), region = lookup(item, "region", null)
  }]
  peering_accepts = [for item in local.peering["accepts"] : {
    id = item["id"], name = item["name"]
  }]
}