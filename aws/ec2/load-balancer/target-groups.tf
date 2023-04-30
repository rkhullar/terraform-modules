resource "aws_lb_target_group" "default" {
  for_each    = { for item in var.target_groups : item["key"] => item }
  name        = each.value["name"]
  name_prefix = each.value["name_prefix"]
  target_type = each.value["target_type"]
  port        = each.value["port"]
  protocol    = each.value["protocol"] != null ? upper(each.value["protocol"]) : null
  vpc_id      = var.vpc_id
  tags        = var.tags

  dynamic "health_check" {
    for_each = each.value["health_check"] != null ? [each.value["health_check"]] : []
    content {
      enabled             = health_check.value["enabled"]
      interval            = health_check.value["interval"]
      path                = health_check.value["path"]
      port                = health_check.value["port"]
      healthy_threshold   = health_check.value["healthy_threshold"]
      unhealthy_threshold = health_check.value["unhealthy_threshold"]
      timeout             = health_check.value["timeout"]
      protocol            = health_check.value["protocol"] != null ? upper(health_check.value["protocol"]) : null
      matcher             = health_check.value["matcher"]
    }
  }
}