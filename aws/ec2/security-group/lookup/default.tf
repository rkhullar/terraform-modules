data "aws_security_groups" "default" {
  for_each = var.names
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "group-name"
    values = [each.value]
  }
  dynamic "filter" {
    for_each = var.tags
    content {
      name   = "tag:${filter.key}"
      values = [filter.value]
    }
  }
}

locals {
  lookup          = zipmap(keys(data.aws_security_groups.default), values(data.aws_security_groups.default)[*].ids)
  security_groups = { for key, arr in local.lookup : key => arr[0] if length(arr) > 0 }
  status          = length(keys(var.names)) == length(keys(local.security_groups))
}