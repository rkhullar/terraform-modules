terraform {
  # the configuration for this backend will be filled in by terragrunt
  backend "s3" {}
  required_version = "~> 1.1"
  experiments      = [module_variable_optional_attrs]
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
}