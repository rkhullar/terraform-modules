variable "id" {
  type        = string
  description = "security_group_id"
}

variable "type" {
  type        = string
  description = "ingress | egress"
  validation {
    condition = contains(["ingress", "egress"], var.type)
  }
}

variable "protocol" {
  type        = string
  description = "tcp | udp | all"
  default     = "tcp"
  validation {
    condition = contains(["tcp", "udp", "all"], var.protocol)
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