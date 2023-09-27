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
  })
}

variable "scopes" {
  nullable = false
  type     = map(string)
  help     = "scope -> description"
}

variable "roles" {
  default  = []
  nullable = false
  type = set(object({
    name        = string
    description = string
    scopes      = list(string)
  }))
}