locals {
  tf_source = var.account_vpc ? var.account : var.project
  src_env   = coalesce(var.vpc_env, var.environment)
  tf_bucket = "${local.tf_source}-terraformstate-${var.region}-${local.src_env}-${var.namespace}"
  mapping   = data.terraform_remote_state.vpc.outputs
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.tf_bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}