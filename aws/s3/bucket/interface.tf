# naming
variable "name" {
  type     = string
  nullable = false
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

# access control
variable "object_ownership" {
  nullable = false
  type     = string
  default  = "BucketOwnerEnforced"
  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Allowed Values: {BucketOwnerPreferred | ObjectWriter | BucketOwnerEnforced}."
  }
}

variable "access" {
  type        = string
  nullable    = false
  default     = ""
  description = "https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl"
  validation {
    condition     = contains(["", "private", "public-read", "public-read-write", "aws-exec-read", "authenticated-read", "bucket-owner-read", "bucket-owner-full-control", "log-delivery-write"], var.access)
    error_message = "Allowed Values: {private | public-read | public-read-write | aws-exec-read | authenticated-read | bucket-owner-read | bucket-owner-full-control | log-delivery-write}."
  }
}

variable "policy" {
  type     = string
  nullable = true
  default  = null
}

variable "attach_policy" {
  type     = bool
  nullable = false
  default  = false
}

variable "versioning" {
  type     = bool
  nullable = false
  default  = true
}

variable "mfa_delete" {
  type     = bool
  nullable = false
  default  = false
}

variable "encryption" {
  type     = bool
  nullable = false
  default  = true
}

variable "algorithm" {
  type     = string
  nullable = false
  default  = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms"], var.algorithm)
    error_message = "Allowed Values: {AES256 | aws:kms}."
  }
}

variable "kms_master_key_id" {
  type     = string
  nullable = false
  default  = "aws/s3"
}

variable "bucket_key_enabled" {
  type     = bool
  nullable = false
  default  = true
}

# misc
variable "force_destroy" {
  type     = bool
  nullable = false
  default  = true
}

variable "cors_rule" {
  nullable = true
  default  = null
  type = object({
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  })
}

variable "lifecycle_rules" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#rule
  nullable = false
  default  = []
  type = list(object({
    id     = string
    enable = optional(bool, true)
    filter = optional(object({}))
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    transition = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })))
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
    noncurrent_version_expiration = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
    }))
    noncurrent_version_transition = optional(list(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = optional(number)
      storage_class             = string
    })))
  }))
}

# public access block
variable "block_public_acls" {
  type     = bool
  nullable = false
  default  = true
}

variable "block_public_policy" {
  type     = bool
  nullable = false
  default  = true
}

variable "ignore_public_acls" {
  type     = bool
  nullable = false
  default  = true
}

variable "restrict_public_buckets" {
  type     = bool
  nullable = false
  default  = true
}

# outputs
output "output" {
  value = aws_s3_bucket.default
}