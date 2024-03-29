locals {
  atlas_region     = upper(replace(var.region, "-", "_"))
  atlas_project_id = data.mongodbatlas_project.default.id
}

data "mongodbatlas_project" "default" {
  name = var.atlas_project
}

resource "mongodbatlas_serverless_instance" "serverless" {
  count                                   = local.create_serverless ? 1 : 0
  project_id                              = local.atlas_project_id
  name                                    = var.atlas_cluster
  provider_settings_backing_provider_name = upper("aws")
  provider_settings_provider_name         = upper("serverless")
  provider_settings_region_name           = local.atlas_region

  dynamic "tags" {
    for_each = local.common_tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
}

resource "mongodbatlas_advanced_cluster" "advanced" {
  count                          = local.create_advanced ? 1 : 0
  project_id                     = local.atlas_project_id
  name                           = var.atlas_cluster
  cluster_type                   = upper("replicaset")
  backup_enabled                 = var.flags.backup
  termination_protection_enabled = var.flags.termination_protection

  replication_specs {
    region_configs {
      priority              = 7
      provider_name         = upper("tenant")
      backing_provider_name = upper("aws")
      region_name           = local.atlas_region
      electable_specs {
        instance_size = "M0"
      }
    }
  }

  dynamic "tags" {
    for_each = local.common_tags
    content {
      key   = tags.key
      value = tags.value
    }
  }
}