resource "aws_ecs_task_definition" "default" {
  count                    = var.flags.enabled ? 1 : 0
  family                   = var.family
  container_definitions    = jsonencode([local.container_definition])
  task_role_arn            = var.roles.task
  execution_role_arn       = var.roles.exec
  network_mode             = var.network_mode
  cpu                      = var.sizing.task.cpu
  memory                   = var.sizing.task.memory
  requires_compatibilities = [for item in var.launch_types : upper(item)]
  tags                     = var.tags

  dynamic "runtime_platform" {
    for_each = var.architecture != null ? [true] : []
    content {
      operating_system_family = upper(var.architecture)
    }
  }

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.type == "bind_mount" ? volume.value.bind_mount.host_path : null

      dynamic "docker_volume_configuration" {
        for_each = volume.value.type == "docker" ? [volume.value.docker] : []
        content {
          scope         = docker_volume_configuration.value["host_port"]
          autoprovision = docker_volume_configuration.value["autoprovision"]
          driver        = docker_volume_configuration.value["driver"]
          driver_opts   = docker_volume_configuration.value["driver_opts"]
          labels        = docker_volume_configuration.value["labels"]
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = volume.value.type == "efs" ? [volume.value.efs] : []
        content {
          file_system_id          = efs_volume_configuration.value["id"]
          root_directory          = efs_volume_configuration.value["root_directory"]
          transit_encryption      = efs_volume_configuration.value["encrypt"] ? "ENABLED" : "DISABLED"
          transit_encryption_port = efs_volume_configuration.value["transit_port"]
          dynamic "authorization_config" {
            for_each = efs_volume_configuration.value["access_point_id"] != null ? [efs_volume_configuration.value] : []
            content {
              access_point_id = authorization_config.value["access_point_id"]
              iam             = authorization_config.value["enable_iam"] ? "ENABLED" : "DISABLED"
            }
          }
        }
      }
    }
  }
}