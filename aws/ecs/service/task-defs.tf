module "default-task-def" {
  source       = "../task-def"
  family       = "${var.name}-default"
  tags         = var.tags
  roles        = lookup(var.task_config, "roles", {})
  launch_types = [var.launch_type]
  architecture = var.architecture
  image        = "public.ecr.aws/docker/library/python:${var.python_version}-bullseye"
  container    = var.name
  environment  = local.default_environment
  ports        = local.ports
  entrypoint   = ["sh", "-c"]
  command      = [local.default_command]
  logging      = { group = aws_cloudwatch_log_group.default.name, prefix = "default" }
  sizing       = { task = { cpu = 256, memory = 512 } }
}

module "target-task-def" {
  source       = "../task-def"
  family       = var.name
  tags         = var.tags
  roles        = lookup(var.task_config, "roles", {})
  launch_types = [var.launch_type]
  architecture = var.architecture
  image        = local.image
  container    = var.name
  environment  = lookup(var.task_config, "environment", {})
  secrets      = lookup(var.task_config, "secrets", {})
  ignore_case  = lookup(var.task_config, "ignore_case", false)
  ports        = local.ports
  entrypoint   = lookup(var.task_config, "entrypoint", [])
  command      = lookup(var.task_config, "command", [])
  logging      = { group = aws_cloudwatch_log_group.target.name, prefix = "default" }
  ulimits      = lookup(var.task_config, "ulimits", [])
  flags        = lookup(var.task_config, "flags", {})
  volumes      = lookup(var.task_config, "volumes", [])
  mount_points = lookup(var.task_config, "mount_points", [])
  sizing       = lookup(var.task_config, "sizing", {})
}