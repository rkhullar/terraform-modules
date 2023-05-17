module "default" {
  source = "../../../s3/bucket"
  name   = var.name
  tags = var.tags
  policy = data.aws_iam_policy_document.default.json
  lifecycle = [
    {id=log-expiration, expiration=var.expiration}
  ]
}

/*
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
*/