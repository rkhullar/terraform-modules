# naming
variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

# access control
variable "access" {
  type        = string
  default     = null
  description = "private | public-read | public-read-write | aws-exec-read | authenticated-read | bucket-owner-read | bucket-owner-full-control | log-delivery-write"
  # https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
}

variable "policy" {
  type    = string
  default = null
}

variable "attach_policy" {
  type    = bool
  default = false
}

variable "versioning" {
  type    = bool
  default = true
}

variable "mfa_delete" {
  type    = bool
  default = false
}

variable "encryption" {
  type    = bool
  default = true
}

variable "algorithm" {
  type        = string
  default     = "AES256"
  description = "AES256 | aws:kms"
}

variable "kms_master_key_id" {
  type    = string
  default = "aws/s3"
}

variable "bucket_key_enabled" {
  type    = bool
  default = false
}

# misc
variable "force_destroy" {
  type    = bool
  default = true
}

variable "cors_rule" {
  type    = any
  default = null
}

# public access block
variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

# outputs
output "output" {
  value = aws_s3_bucket.default
}