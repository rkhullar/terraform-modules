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

output "output" {
  value = aws_lambda_layer_version.default
}