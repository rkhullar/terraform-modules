# general
variable "account" { type = string }
variable "project" { type = string }
variable "owner" { type = string }
variable "namespace" { type = string }

variable "account_id" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "default_region" { type = string }

# module
variable "atlas_project" {
  type     = string
  nullable = false
}

variable "atlas_cluster" {
  type     = string
  nullable = false
}

variable "cluster_type" {
  type     = string
  nullable = false
  validation {
    # TODO: add support for dedicated
    condition     = contains(["shared", "serverless"], var.cluster_type)
    error_message = "Allowed Values: cluster_type -> {shared, serverless}."
  }
}

variable "flags" {
  default  = {}
  nullable = false
  type = object({
    backup                 = optional(bool, false)
    termination_protection = optional(bool, false)
    create_admin           = optional(bool, false)
    render_role            = optional(bool, true)
    role_prefix            = optional(string)
    role_suffix            = optional(string)
  })
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

# output
output "public_host" {
  value = local.public_atlas_host
}