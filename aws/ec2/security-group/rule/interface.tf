variable "enable" {
  type     = bool
  nullable = false
  default  = true
}

variable "id" {
  type        = string
  nullable    = false
  description = "security_group_id"
}

variable "type" {
  type     = string
  nullable = false
  validation {
    condition     = contains(["ingress", "egress"], var.type)
    error_message = "Allowed Values: {ingress | egress}."
  }
}

variable "protocol" {
  type     = string
  nullable = false
  default  = "tcp"
  validation {
    condition     = contains(["tcp", "udp", "all", "-1"], var.protocol)
    error_message = "Allowed Values: {tcp | udp | all}."
  }
}

variable "ports" {
  type     = set(number)
  nullable = false
  default  = []
}

variable "port_ranges" {
  type     = set(string)
  nullable = false
  default  = []
}

variable "sources" {
  type        = list(string)
  nullable    = false
  description = "cidr_block | security_group | prefix_list | self"
}

variable "aliases" {
  type        = map(string)
  nullable    = false
  default     = {}
  description = "name -> source"
}

output "detail" {
  value = local.detail_map
}