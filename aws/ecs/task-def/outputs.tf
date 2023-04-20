output default {
  value = local.flags["enabled"] ? aws_ecs_task_definition.default[0] : null
}

output container {
  value = local.container_definition
}