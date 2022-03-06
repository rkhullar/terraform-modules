variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "zone_count" {
  type    = number
  default = 3
}

variable "flags_default" {
  type = object({
    enable_dns_support      = bool
    enable_dns_hostnames    = bool
    map_public_ip_on_launch = bool
    enable_nat              = bool
    single_nat              = bool
  })
  default = {
    enable_dns_support      = true
    enable_dns_hostnames    = true
    map_public_ip_on_launch = false
    enable_nat              = true
    single_nat              = false
  }
}

variable "flags" {
  type    = map(bool)
  default = {}
}

output "debug" {
  value = var.cidr
}