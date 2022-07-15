locals {
  container_properties = {
    # https://docs.aws.amazon.com/batch/latest/APIReference/API_ContainerProperties.html
    command                      = var.command
    environment                  = local.environment
    executionRoleArn             = local.exec_role
    fargatePlatformConfiguration = { platformVersion = var.fargate_platform_version }
    image                        = var.image
    jobRoleArn                   = var.roles.task
    resourceRequirements         = local.resources
    mountPoints                  = local.mount_points
    volumes                      = local.volumes
  }
}

locals {
  # TODO: create module for processing environment variables?
  environment = [for key, value in var.environment : {
    name  = (var.ignore_case ? key : replace(upper(key), "-", "_"))
    value = value
  }]
  mount_points = [for mount_point in var.mount_points : {
    sourceVolume  = mount_point["source_volume"]
    containerPath = mount_point["container_path"]
    readOnly      = mount_point["read_only"]
  }]
  volumes = [for volume in var.volumes : {
    name = volume["name"]
    efsVolumeConfiguration = {
      # NOTE: don't need to specify rootDirectory or transitEncryptionPort
      fileSystemId      = volume["file_system"]
      transitEncryption = "ENABLED"
      authorizationConfig = {
        accessPointId = volume["access_point"]
        iam           = "ENABLED"
      }
    }
  }]
}