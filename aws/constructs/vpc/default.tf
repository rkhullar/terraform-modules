terraform {
  backend "s3" {}
}

module "default" {
  source = "../../ec2/vpc"
  cidr = var.cidr
}