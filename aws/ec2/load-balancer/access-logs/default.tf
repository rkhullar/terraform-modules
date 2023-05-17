module "bucket" {
  source = "../../../s3/bucket"
  name   = var.name
  tags   = var.tags
  access = "private"
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  bucket = module.bucket.output.id
  rule {
    id     = "log-expiration"
    status = "Enabled"
    expiration {
      days = var.expiration
    }
  }
}