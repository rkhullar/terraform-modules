module "bucket" {
  source        = "../../../s3/bucket"
  name          = var.name
  tags          = var.tags
  versioning    = var.versioning
  access        = "private"
  policy        = data.aws_iam_policy_document.default.json
  attach_policy = true
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = module.bucket.output.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
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