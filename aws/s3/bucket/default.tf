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

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "default" {
  depends_on = [aws_s3_bucket_ownership_controls.default]
  count      = var.access != "" ? 1 : 0
  bucket     = aws_s3_bucket.default.id
  acl        = var.access
}

resource "aws_s3_bucket_policy" "default" {
  count  = var.attach_policy && var.policy != null ? 1 : 0
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

locals {
  lifecycle_rules_with_filter_map = { for rule in var.lifecycle_rules : rule.id => rule if rule.filter != null }
  lifecycle_rules_with_filter_set = keys(local.lifecycle_rules_with_filter_map)
  lifecycle_rules_filter_map = { for id in local.lifecycle_rules_with_filter_set : id => {
    for key, value in local.lifecycle_rules_with_filter_map[id] : key => value if value != null
  } }
  lifecycle_rules_filter_map_size        = { for id, filter in local.lifecycle_rules_filter_map : id => length(keys(filter)) }
  lifecycle_rules_filter_tags            = { for id, filter in local.lifecycle_rules_filter_map : id => lookup(filter, "tags", {}) }
  lifecycle_rules_filter_tags_size       = { for id, tags in local.lifecycle_rules_filter_tags : id => length(tags) }
  lifecycle_rules_with_single_filter_set = [for id in local.lifecycle_rules_with_filter_set : id if max(local.lifecycle_rules_filter_map_size[id], local.lifecycle_rules_filter_tags_size[id]) == 1]
  lifecycle_rules_with_mixed_filter_set  = [for id in local.lifecycle_rules_with_filter_set : id if max(local.lifecycle_rules_filter_map_size[id], local.lifecycle_rules_filter_tags_size[id]) > 1]
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#rule
  # https://github.com/terraform-aws-modules/terraform-aws-s3-bucket/blob/96226df43f789bdc4c3c0f2c8306ba0cf8e95605/main.tf#L215-L328
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.default.id
  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.enable ? "Enabled" : "Disabled"

      dynamic "expiration" {
        # NOTE: https://github.com/hashicorp/terraform/issues/28264
        for_each = [for item in [rule.value.expiration] : item if item != null]
        content {
          date                         = expiration.value.date
          days                         = expiration.value.days
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }

      dynamic "transition" {
        for_each = rule.value.transition
        content {
          date          = transition.value.date
          days          = transition.value.days
          storage_class = upper(transition.value.storage_class)
        }
      }

      dynamic "abort_incomplete_multipart_upload" {
        for_each = [for item in [rule.value.abort_incomplete_multipart_upload] : item if item != null]
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value.days_after_initiation
        }
      }

      dynamic "noncurrent_version_expiration" {
        for_each = [for item in [rule.value.noncurrent_version_expiration] : item if item != null]
        content {
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition
        content {
          newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          storage_class             = upper(noncurrent_version_transition.value.storage_class)
        }
      }

      # filter with one condition or tag
      dynamic "filter" {
        for_each = [for item in [rule.value.filter] : item if contains(local.lifecycle_rules_with_single_filter_set, rule.value.id)]
        content {
          object_size_greater_than = filter.value.object_size_greater_than
          object_size_less_than    = filter.value.object_size_less_than
          prefix                   = filter.value.prefix
          dynamic "tag" {
            for_each = coalesce(filter.value.tags, {})
            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # filter with more than one condition or tag
      dynamic "filter" {
        for_each = [for item in [rule.value.filter] : item if contains(local.lifecycle_rules_with_mixed_filter_set, rule.value.id)]
        content {
          and {
            object_size_greater_than = filter.value.object_size_greater_than
            object_size_less_than    = filter.value.object_size_less_than
            prefix                   = filter.value.prefix
            tags                     = filter.value.tags
          }
        }
      }
    }
  }
}