variable "name" {
  type     = string
  nullable = false
}

variable "subnet_groups" {
  type     = set(string)
  default  = ["public", "private", "data"]
  nullable = false
}

variable "subnet_regex_default" {
  nullable = false
  type = object({
    public  = string
    private = string
    data    = string
  })
  default = {
    public  = "public-subnet-1*"
    private = "private-subnet-1*"
    data    = "private-subnet-2*"
  }
}

variable "subnet_regex" {
  type     = map(string)
  default  = {}
  nullable = false
}

locals {
  subnet_regex = merge(var.subnet_regex_default, var.subnet_regex)
}