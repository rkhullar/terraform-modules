data aws_region default {}

locals {
  flags            = merge(var.flags_default, var.flags)
  roles            = merge(var.roles_default, var.roles)
  logging_defaults = { region = data.aws_region.default.name, prefix = local.container }
  logging          = merge(var.logging_defaults, local.logging_defaults, var.logging)
  container        = coalesce(var.container, var.family) # container name
  sizing_task      = merge(var.sizing_defaults.task, lookup(var.sizing, "task", {}))
  sizing_container = merge(var.sizing_defaults.container, lookup(var.sizing, "container", {}))
  sizing           = { task = local.sizing_task, container = local.sizing_container }
}

module envs-list {
  source      = "../../random/upper-map"
  input       = var.envs
  ignore_case = var.ignore_case
  value_type  = "value"
}

module secrets-list {
  source      = "../../random/upper-map"
  input       = var.secrets
  ignore_case = var.ignore_case
  value_type  = "valueFrom"
}

locals {
  ports_list   = [for port in var.ports : { containerPort = tonumber(port) }]
  ulimits_list = [for item in var.ulimits : { name = item["name"], hardLimit = item["hard-limit"], softLimit = item["soft-limit"] }]
}

locals {
  log_config = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = local.logging["group"]
      awslogs-region        = local.logging["region"]
      awslogs-stream-prefix = local.logging["prefix"]
    }
  }
}

locals {
  linux_params = {
    initProcessEnabled = local.flags["docker-init"]
  }
}

locals {
  mount_points = [
    for item in var.mount_points : {
      sourceVolume  = item["volume"]
      containerPath = item["container_path"]
      readOnly      = lookup(item, "read_only", null)
    }
  ]
}

locals {
  container_definition = {
    name              = local.container
    image             = var.image
    essential         = local.flags["essential"]
    logConfiguration  = local.log_config
    environment       = module.envs-list.output
    secrets           = module.secrets-list.output
    portMappings      = local.ports_list
    entryPoint        = var.entrypoint
    command           = var.command
    ulimits           = local.ulimits_list
    linuxParameters   = local.linux_params
    mountPoints       = local.mount_points
    cpu               = local.sizing.container["cpu"]
    memory            = local.sizing.container["memory"]
    memoryReservation = local.sizing.container["memory-reservation"]
  }
}