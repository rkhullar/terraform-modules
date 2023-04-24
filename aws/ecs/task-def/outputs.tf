output "default" {
  value = one(aws_ecs_task_definition.default)
}

output "container" {
  value = local.container_definition
}