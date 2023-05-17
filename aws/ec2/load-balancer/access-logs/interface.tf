variable "name" {
  type     = string
  nullable = false
}

variable "shared" {
  type     = bool
  nullable = false
  default  = true
}

variable "versioning" {
  type     = bool
  nullable = false
  default  = false
}

variable "expiration" {
  type     = number
  nullable = false
  default  = 14
}

variable "prefix" {
  type     = string
  nullable = true
  default  = null
}

variable "tags" {
  type     = map(string)
  nullable = false
  default  = {}
}

output "output" {
  value = module.bucket.output
}