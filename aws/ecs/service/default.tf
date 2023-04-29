resource "aws_ecs_service" "default" {
  depends_on              = [module.default-task-def, module.target-task-def]
  name                    = var.name
  tags                    = var.tags
  cluster                 = data.aws_ecs_cluster.default.arn
  launch_type             = length(var.capacity_providers) > 0 ? null : upper(var.launch_type)
  propagate_tags          = var.propagate_tags != null ? replace(upper(var.propagate_tags), "-", "_") : null
  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  force_new_deployment    = var.force_new_deployment
  desired_count           = lookup(var.capacity, "desired", 1)
  task_definition         = var.skip_default ? local.task_def_arns.target : local.task_def_arns.default
  iam_role                = var.iam_role
  platform_version        = var.launch_type == "fargate" ? upper(var.platform_version) : null

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_providers
    content {
      capacity_provider = capacity_provider_strategy.value["name"]
      weight            = capacity_provider_strategy.value["weight"]
      base              = capacity_provider_strategy.value["base"]
    }
  }

  dynamic "load_balancer" {
    for_each = local.load_balancers
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = lookup(load_balancer.value, "container_name", var.name)
      container_port   = lookup(load_balancer.value, "container_port", local.target_port)
    }
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
}

module "autoscaling" {
  source         = "./autoscaling"
  cluster        = data.aws_ecs_cluster.default.cluster_name
  service        = var.name
  enable         = lookup(var.autoscaling, "enable", {})
  capacity       = var.capacity
  cooldown       = lookup(var.autoscaling, "cooldown", {})
  target         = lookup(var.autoscaling, "target", null)
  metric         = lookup(var.autoscaling, "metric", null)
  resource_label = lookup(var.autoscaling, "resource_label", null)
}