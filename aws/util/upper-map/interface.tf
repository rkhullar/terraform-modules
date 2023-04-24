variable "input" {
  type     = map(string)
  nullable = false
  default  = {}
}

variable "ignore_case" {
  type     = bool
  nullable = false
  default  = false
}

variable "value_type" {
  type     = string
  nullable = false
}

locals {
  keys_upper = [for key in keys(var.input) : replace(upper(key), "-", "_")]
  keys       = var.ignore_case ? keys(var.input) : local.keys_upper
  values     = values(var.input)
  output = [for i in range(length(var.input)) : {
    name           = local.keys[i],
    var.value_type = local.values[i]
  }]
}

output "output" {
  value = local.output
}