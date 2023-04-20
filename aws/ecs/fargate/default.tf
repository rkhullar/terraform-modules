resource aws_ecs_cluster default {
  name               = var.name
  tags               = var.tags
  capacity_providers = [for item in local.capacity_providers : item["name"]]

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  dynamic default_capacity_provider_strategy {
    for_each = var.enable_default_strategy ? local.capacity_providers : []
    content {
      capacity_provider = default_capacity_provider_strategy.value["name"]
      weight            = lookup(default_capacity_provider_strategy.value, "weight", null)
      base              = lookup(default_capacity_provider_strategy.value, "base", null)
    }
  }
}

locals {
  capacity_providers = [
    for item in var.capacity_providers :
    merge(item, { name = replace(upper(item["name"]), "-", "_") })
    if contains(keys(item), "name")
  ]
}