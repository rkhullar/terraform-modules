output output {
  value = aws_lb.default
}

output target_groups {
  value = aws_lb_target_group.default
}

output listeners {
  value = aws_lb_listener.default
}

output resource_labels {
  value = { for name, group in aws_lb_target_group.default : name => "${aws_lb.default.arn_suffix}/${group["arn_suffix"]}" }
}