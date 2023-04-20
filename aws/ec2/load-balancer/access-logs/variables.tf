variable name {
  type = string
}

variable shared {
  type    = bool
  default = true
}

variable expiration {
  type    = number
  default = 14
}

variable prefix {
  type    = string
  default = null
}

variable tags {
  type    = map(string)
  default = {}
}