resource "aws_lb_target_group" "default" {
  for_each    = { for item in var.target_groups : item["key"] => item }
  name        = lookup(each.value, "name", null)
  name_prefix = lookup(each.value, "name_prefix", null)
  target_type = lookup(each.value, "target_type", null)
  port        = lookup(each.value, "port", null)
  protocol    = contains(keys(each.value), "protocol") ? upper(each.value["protocol"]) : null
  vpc_id      = var.vpc_id
  tags        = var.tags

  dynamic "health_check" {
    for_each = contains(keys(each.value), "health_check") ? [each.value["health_check"]] : []
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = contains(keys(health_check.value), "protocol") ? upper(health_check.value["protocol"]) : null
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }
}