resource "aws_s3_bucket" "default" {
  bucket        = var.name
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    id     = "log-expiration"
    status = "Enabled"
    expiration {
      days = var.expiration
    }
  }
}