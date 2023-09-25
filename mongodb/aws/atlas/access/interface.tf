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

variable "ingress_sources" {
  default  = []
  nullable = false
  type = set(object({
    source  = string
    comment = string
  }))
}

# TODO: adopt role_template and role_template_params if template function becomes available

variable "role_prefix" {
  type     = string
  nullable = false
  default  = null
}

variable "role_suffix" {
  type     = string
  nullable = false
  default  = null
}