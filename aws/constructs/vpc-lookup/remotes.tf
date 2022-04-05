locals {
  remote = defaults(coalesce(var.remote, {}), {
    account     = true
    environment = ""
  })
}

locals {
  tf_source   = local.remote.account ? var.account : var.project
  environment = coalesce(local.remote.environment, var.environment)
  tf_bucket   = "${local.tf_source}-terraformstate-${var.region}-${local.environment}-${var.namespace}"
  mapping     = data.terraform_remote_state.vpc.outputs
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.tf_bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}