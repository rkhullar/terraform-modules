variable "name" {
  type     = string
  nullable = false
}

variable "identifier" {
  type     = string
  nullable = false
}

variable "flags" {
  default  = {}
  nullable = false
  type = object({
    enable_rbac          = optional(bool, true)
    include_permissions  = optional(bool, false)
    allow_offline_access = optional(bool, true)
    skip_user_consent    = optional(bool, true)
    delimiter            = optional(string, "/")
    enable_prefix        = optional(bool, true)
  })
}

variable "scopes" {
  nullable    = false
  type        = map(string)
  description = "scope -> description"
}

variable "roles" {
  default  = []
  nullable = false
  type = set(object({
    name          = string
    description   = string
    scopes        = list(string)
    delimiter     = optional(string)
    enable_prefix = optional(bool)
  }))
}