resource "aws_appautoscaling_target" "default" {
  count              = var.enable.out ? 1 : 0
  min_capacity       = var.capacity.min
  max_capacity       = var.capacity.max
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  resource_id        = "service/${var.cluster}/${var.service}"
}

resource "aws_appautoscaling_policy" "default" {
  count              = var.enable.out ? 1 : 0
  name               = aws_appautoscaling_target.default[0].resource_id
  resource_id        = aws_appautoscaling_target.default[0].resource_id
  scalable_dimension = aws_appautoscaling_target.default[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.default[0].service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.target
    disable_scale_in   = !var.enable.in
    scale_in_cooldown  = var.cooldown.in
    scale_out_cooldown = var.cooldown.out
    predefined_metric_specification {
      predefined_metric_type = var.metric
      resource_label         = var.resource_label
    }
  }
}