variable "project" {
  type     = string
  nullable = false
}

variable "cluster" {
  type     = string
  nullable = false
}

variable "create_admin" {
  type     = bool
  nullable = false
  default  = false
}

variable "access_rules" {
  default  = []
  nullable = false
  type = set(object({
    role       = string
    database   = string
    collection = string
    access     = string
  }))
}

variable "role_prefix" {
  type     = string
  nullable = true
  default  = null
}

variable "role_suffix" {
  type     = string
  nullable = true
  default  = null
}

variable "ingress_sources" {
  default  = []
  nullable = false
  type = set(object({
    source  = string
    comment = string
  }))
}