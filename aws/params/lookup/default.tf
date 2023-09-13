data "aws_ssm_parameter" "default" {
  for_each = var.names
  name     = "/${var.project}/${var.environment}/${each.value}"
}

locals {
  values = { for name in var.names : name => nonsensitive(data.aws_ssm_parameter.default[name].value) }
}