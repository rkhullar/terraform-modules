# security group resource
variable "name" {
  type    = string
  default = null
}

variable "name_prefix" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_id" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

# ingress rules module
variable "ingress_defaults" {
  type = object({
    enable      = bool
    protocol    = string # tcp | udp | all
    ports       = list(number)
    port_ranges = list(string)
    sources     = list(string)
  })
  default = {
    enable      = true
    protocol    = "tcp"
    ports       = []
    port_ranges = []
    sources     = []
  }
}

variable "ingress" {
  type    = any
  default = {}
}

# egress rules module
variable "egress_defaults" {
  type = object({
    enable      = bool
    protocol    = string # tcp | udp | all
    ports       = list(number)
    port_ranges = list(string)
    targets     = list(string)
  })
  default = {
    enable      = true
    protocol    = "tcp"
    ports       = []
    port_ranges = []
    targets     = []
  }
}

variable "egress" {
  type    = any
  default = {}
}

# custom
variable "aliases" {
  type    = map(string)
  default = {}
}

# outputs
output "id" {
  value = aws_security_group.default.id
}

output "arn" {
  value = aws_security_group.default.arn
}

output "rules" {
  value = {
    ingress = module.ingress-rules.detail
    egress  = module.egress-rules.detail
  }
}