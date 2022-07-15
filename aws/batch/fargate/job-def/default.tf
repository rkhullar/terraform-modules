locals {
  params    = { for key, val in var.params : key => coalesce(val, " ") }
  exec_role = coalesce(var.roles.exec, data.aws_iam_role.default-exec.arn)
  resources = [for key, val in var.resources : { type = upper(key), value = tostring(val) } if val != null]
}

data "aws_iam_role" "default-exec" {
  name = "ecsTaskExecutionRole"
}

resource "aws_batch_job_definition" "default" {
  name                  = var.name
  type                  = "container"
  platform_capabilities = [upper("fargate")]
  tags                  = var.tags
  propagate_tags        = var.propagate_tags
  parameters            = local.params
  container_properties  = jsonencode(local.container_properties)

  dynamic "retry_strategy" {
    for_each = compact([var.attempts])
    content {
      attempts = var.attempts
    }
  }

  dynamic "timeout" {
    for_each = compact([var.duration])
    content {
      attempt_duration_seconds = var.duration
    }
  }
}