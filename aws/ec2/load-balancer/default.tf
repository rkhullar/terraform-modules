/*
 * inspired from official aws module with for_each for repetition instead of count
 * https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/5.0.0
 */

resource "aws_lb" "default" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = var.type
  security_groups    = var.security_groups
  subnets            = var.subnets
  idle_timeout       = var.idle_timeout
  tags               = var.tags

  dynamic "access_logs" {
    for_each = var.access_logs == null ? [] : [var.access_logs]
    content {
      enabled = access_logs.value["enabled"]
      bucket  = access_logs.value["bucket"]
      prefix  = access_logs.value["prefix"]
    }
  }
}