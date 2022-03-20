variable "id" {
  type        = string
  description = "security_group_id"
}

variable "type" {
  type = string
  validation {
    condition     = contains(["ingress", "egress"], var.type)
    error_message = "Allowed Values: {ingress | egress}."
  }
}

variable "protocol" {
  type    = string
  default = "tcp"
  validation {
    condition     = contains(["tcp", "udp", "all"], var.protocol)
    error_message = "Allowed Values: {tcp | udp | all}."
  }
}

variable "ports" {
  type    = set(number)
  default = []
}

variable "port_ranges" {
  type    = set(string)
  default = []
}

variable "sources" {
  type        = list(string)
  description = "cidr_block | security_group | prefix_list | self"
}

variable "aliases" {
  type        = map(string)
  description = "name -> security_group_id"
  default     = {}
}

locals {
  error_x = "Allowed Values: {}."
}

variable "x" {
  type = string
  validation {
    condition = contains(["a", "b"], var.x)
    error_message = local.error_x
  }
}