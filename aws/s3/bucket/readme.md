#### Example
```terraform
module "bucket" {
  source = "path/to/s3/bucket"
  name   = "bucket-name"
  lifecycle_rules = [
    {
      id                                = "test"
      abort_incomplete_multipart_upload = { days_after_initiation = 7 }
      expiration                        = { days = 60 }
      transition                        = [{ days = 30, storage_class = "standard_ia" }]
    }
  ]
}
```
