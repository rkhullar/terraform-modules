locals {
  bucket = "${var.project}-terraformstate-${var.region}-${var.environment}-${var.namespace}"
  vpc    = data.terraform_remote_state.vpc.outputs
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}