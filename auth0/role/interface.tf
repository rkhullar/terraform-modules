variable "name" {
  type     = string
  nullable = false
}

variable "description" {
  type     = string
  nullable = false
}

variable "permissions" {
  type     = map(list(string))
  nullable = false
  default  = {}
  help     = "resource_server_identifier -> scopes"
}