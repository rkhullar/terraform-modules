variable "name" {
  type     = string
  nullable = false
}

variable "runtimes" {
  type     = list(string)
  nullable = false
}

variable "architectures" {
  type     = list(string)
  nullable = false
}

variable "template" {
  type     = string
  nullable = false
  default  = "shell"
}

variable "description" {
  type     = string
  nullable = true
  default  = null
}

output "output" {
  value = aws_lambda_layer_version.default
}