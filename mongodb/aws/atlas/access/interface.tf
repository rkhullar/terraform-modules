variable "create_atlas_admin" {
  type     = bool
  nullable = false
  default  = false
}

variable "ingress_sources" {
  default  = []
  nullable = false
  type = set(object({
    source  = string
    comment = string
  }))
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