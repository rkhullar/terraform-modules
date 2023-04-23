data "aws_elb_service_account" "default" {}

locals {
  share_part = var.shared ? "*" : null
  path_parts = [var.name, var.prefix, local.share_part, "AWSLogs", "*"]
  path_uri   = join("/", compact(local.path_parts))
}

data "aws_iam_policy_document" "default" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_elb_service_account.default.id}:root"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.path_uri}"]
  }
}