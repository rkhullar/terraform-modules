resource "aws_ssm_parameter" "managed" {
  for_each = var.managed
  name     = "${var.prefix}${each.key}"
  type     = "String"
  value    = each.value
  tags     = var.tags
}

resource "aws_ssm_parameter" "secret" {
  for_each = var.secrets
  name     = "${var.prefix}${each.key}"
  type     = "SecureString"
  value    = "default"
  tags     = var.tags
  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "custom" {
  for_each = { for item in var.custom : item["name"] => item }
  name     = "${var.prefix}${each.key}"
  type     = each.value["type"]
  value    = each.value["value"]
  tags     = var.tags
  lifecycle {
    ignore_changes = [value]
  }
}