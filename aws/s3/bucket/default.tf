resource "aws_s3_bucket" "default" {
  bucket        = var.name
  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_acl" "default" {
  bucket = aws_s3_bucket.default.id
  acl    = var.access
}

resource "aws_s3_bucket_policy" "default" {
  count  = var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.default.id
  policy = var.policy
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
    # NOTE: specifying mfa_delete results in an xml error from s3 during apply
    # mfa_delete = var.mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count  = var.encryption ? 1 : 0
  bucket = aws_s3_bucket.default.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.algorithm
      kms_master_key_id = var.algorithm == "aws:kms" ? var.kms_master_key_id : null
    }
    bucket_key_enabled = var.bucket_key_enabled
  }
}

resource "aws_s3_bucket_cors_configuration" "default" {
  count  = var.cors_rule != null ? 1 : 0
  bucket = aws_s3_bucket.default.id
  dynamic "cors_rule" {
    for_each = [var.cors_rule]
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = [for item in cors_rule.value.allowed_methods : upper(item)]
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}