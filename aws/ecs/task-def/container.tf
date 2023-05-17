data "aws_region" "default" {}

locals {
  container_name = coalesce(var.container, var.family)
  logging        = merge(var.logging, { region = coalesce(var.logging.region, data.aws_region.default.name) })
}

module "environment-list" {
  source      = "../../util/map-to-list"
  input       = var.environment
  ignore_case = var.ignore_case
  value_type  = "value"
}

module "secrets-list" {
  source      = "../../util/map-to-list"
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
    initProcessEnabled = var.flags.docker-init
  }
}

locals {
  mount_points = [
    for item in var.mount_points : {
      sourceVolume  = item["volume"]
      containerPath = item["container_path"]
      readOnly      = item["read_only"]
    }
  ]
}

locals {
  container_definition = {
    name              = local.container_name
    image             = var.image
    essential         = var.flags.essential
    logConfiguration  = local.log_config
    environment       = module.environment-list.output
    secrets           = module.secrets-list.output
    portMappings      = local.ports_list
    entryPoint        = var.entrypoint
    command           = var.command
    ulimits           = local.ulimits_list
    linuxParameters   = local.linux_params
    mountPoints       = local.mount_points
    cpu               = var.sizing.container.cpu
    memory            = var.sizing.container.memory
    memoryReservation = var.sizing.container.memory-reservation
  }
}