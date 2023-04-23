resource "aws_ecs_task_definition" "default" {
  count                    = local.flags["enabled"] ? 1 : 0
  family                   = var.family
  container_definitions    = jsonencode([local.container_definition])
  task_role_arn            = local.roles["task"]
  execution_role_arn       = local.roles["exec"]
  network_mode             = var.network_mode
  cpu                      = local.sizing.task["cpu"]
  memory                   = local.sizing.task["memory"]
  requires_compatibilities = [for item in var.launch_types : upper(item)]
  tags                     = var.tags

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.type == "bind_mount" ? lookup(volume.value, "host_path") : null

      dynamic "docker_volume_configuration" {
        for_each = volume.value.type == "docker" ? [volume.value] : []
        content {
          scope         = lookup(docker_volume_configuration.value, "host_port", null)
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = volume.value.type == "efs" ? [volume.value] : []
        content {
          file_system_id          = efs_volume_configuration.value["id"]
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = contains(keys(efs_volume_configuration.value), "encrypt") ? (efs_volume_configuration.value["encrypt"] ? "ENABLED" : "DISABLED") : null
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_port", null)
          dynamic "authorization_config" {
            for_each = contains(keys(efs_volume_configuration.value), "access_point_id") ? [efs_volume_configuration.value] : []
            content {
              access_point_id = authorization_config.value["access_point_id"]
              iam             = contains(keys(authorization_config.value), "enable_iam") ? (authorization_config.value["enable_iam"] ? "ENABLED" : "DISABLED") : null
            }
          }
        }
      }
    }
  }
}