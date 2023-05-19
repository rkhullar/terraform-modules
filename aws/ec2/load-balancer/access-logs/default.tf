module "bucket" {
  source          = "../../../s3/bucket"
  name            = var.name
  tags            = var.tags
  versioning      = var.versioning
  policy          = data.aws_iam_policy_document.default.json
  lifecycle_rules = coalesce(var.lifecycle_rules, [local.default_lifecycle_rule])
}

locals {
  default_lifecycle_rule = {
    id         = "log-expiration"
    expiration = { days = var.expiration }
  }
}