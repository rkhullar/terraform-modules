resource aws_s3_bucket default {
  bucket        = var.name
  policy        = data.aws_iam_policy_document.logs.json
  tags          = var.tags
  force_destroy = true

  lifecycle_rule {
    id      = "log-expiration"
    enabled = true

    expiration {
      days = var.expiration
    }
  }
}

resource aws_s3_bucket_public_access_block logs {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}