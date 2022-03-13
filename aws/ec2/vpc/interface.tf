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

variable "nat_zone" {
  type    = number
  default = null
}

# random
variable "subnet_prefix_defaults" {
  type = object({
    public  = string
    private = string
    data    = string
  })
  default = {
    public  = "public-subnet-1"
    private = "private-subnet-1"
    data    = "private-subnet-2"
  }
}

variable "subnet_prefix" {
  type    = map(string)
  default = {}
}

# peering
variable "peering_requests" {
  # NOTE: owner and region are nullable here; optional in construct
  type    = list(object({ id = string, name = string, owner = string, region = string }))
  default = []
}

variable "peering_accepts" {
  type    = list(object({ id = string, name = string }))
  default = []
}

# routes

# outputs
output "id" {
  value = aws_vpc.default.id
}

output "cidr" {
  value = aws_vpc.default.cidr_block
}

output "subnets" {
  value = local.subnet_ids
}