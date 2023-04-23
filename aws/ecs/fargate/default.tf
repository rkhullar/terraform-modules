resource "aws_ecs_cluster" "default" {
  name = var.name
  tags = var.tags
  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "default" {
  cluster_name       = aws_ecs_cluster.default.name
  capacity_providers = [for item in var.capacity_providers : item["name"]]
  dynamic "default_capacity_provider_strategy" {
    for_each = var.enable_default_strategy ? var.capacity_providers : []
    content {
      capacity_provider = default_capacity_provider_strategy.value["name"]
      weight            = default_capacity_provider_strategy.value["weight"]
      base              = default_capacity_provider_strategy.value["base"]
    }
  }
}