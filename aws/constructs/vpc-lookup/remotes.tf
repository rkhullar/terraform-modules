locals {
  remote = {
    source      = var.shared ? var.account : var.project
    environment = coalesce(var.remote_environment, var.environment)
  }
}

locals {
  bucket  = "${local.remote.source}-terraformstate-${var.region}-${local.remote.environment}-${var.namespace}"
  mapping = data.terraform_remote_state.vpc.outputs
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}