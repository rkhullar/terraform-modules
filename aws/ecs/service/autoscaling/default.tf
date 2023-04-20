locals {
  enable   = merge(var.enable_defaults, var.enable)
  capacity = merge(var.capacity_defaults, var.capacity)
  cooldown = merge(var.cooldown_defaults, var.cooldown)
  target   = coalesce(var.target, var.target_default)
  metric   = coalesce(var.metric, var.metric_default)
}

resource aws_appautoscaling_target default {
  count              = local.enable["out"] ? 1 : 0
  min_capacity       = local.capacity["min"]
  max_capacity       = local.capacity["max"]
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster}/${var.service}"
}

resource aws_appautoscaling_policy default {
  count              = local.enable["out"] ? 1 : 0
  name               = aws_appautoscaling_target.default[0].resource_id
  resource_id        = aws_appautoscaling_target.default[0].resource_id
  scalable_dimension = aws_appautoscaling_target.default[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[0].service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = local.target
    disable_scale_in   = ! local.enable["in"]
    scale_in_cooldown  = local.cooldown["in"]
    scale_out_cooldown = local.cooldown["out"]
    predefined_metric_specification {
      predefined_metric_type = local.metric
      resource_label         = var.resource_label
    }
  }
}