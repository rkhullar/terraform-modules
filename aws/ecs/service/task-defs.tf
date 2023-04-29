module "default-task-def" {
  source       = "../task-def"
  family       = "${var.name}-default"
  tags         = var.tags
  roles        = lookup(var.task_config, "roles", {})
  launch_types = [var.launch_type]
  architecture = var.architecture
  image        = "python:${var.python_version}-alpine"
  container    = var.name
  envs         = local.default_envs
  ports        = local.ports
  entrypoint   = ["python", "-c"]
  command      = [local.default_command]
  logging      = { group = aws_cloudwatch_log_group.default.name, prefix = "default" }
  sizing       = { task = { cpu = 512, memory = 1024 } }
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
  envs         = lookup(var.task_config, "envs", {})
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