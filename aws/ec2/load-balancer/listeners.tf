locals {
  listener_map     = { for item in var.listeners : item["port"] => item }
  secure_listeners = toset([for item in var.listeners : item["port"] if contains(["HTTPS", "TLS"], upper(item["protocol"]))])
  listener_certs   = toset([for name in local.secure_listeners : local.listener_map[name]["cert"]])
}

data "aws_acm_certificate" "default" {
  for_each    = local.listener_certs
  domain      = each.value
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "default" {
  depends_on        = [aws_lb.default, aws_lb_target_group.default]
  for_each          = local.listener_map
  load_balancer_arn = aws_lb.default.arn
  port              = each.value["port"]
  protocol          = upper(each.value["protocol"])
  ssl_policy        = contains(local.secure_listeners, each.value["port"]) ? coalesce(each.value["ssl_policy"], var.ssl_policy) : null
  certificate_arn   = contains(local.secure_listeners, each.value["port"]) ? data.aws_acm_certificate.default[each.value["cert"]].arn : null

  default_action {
    type             = each.value["action"]
    target_group_arn = each.value["action"] == "forward" ? aws_lb_target_group.default[each.value["forward"]["target_group"]].arn : null

    dynamic "redirect" {
      for_each = each.value["action"] == "redirect" ? [each.value["redirect"]] : []
      content {
        path        = redirect.value["path"]
        host        = redirect.value["host"]
        port        = redirect.value["port"]
        protocol    = redirect.value["protocol"] != null ? upper(redirect.value["protocol"]) : null
        query       = redirect.value["query"]
        status_code = redirect.value["status_code"]
      }
    }

    dynamic "fixed_response" {
      for_each = each.value["action"] == "fixed-response" ? [each.value["fixed_response"]] : []
      content {
        content_type = fixed_response.value["content_type"]
        message_body = lookup(fixed_response.value, "message_body", null)
        status_code  = lookup(fixed_response.value, "status_code", null)
      }
    }

    # TODO: support authenticate-cognito and authenticate-oidc actions
  }
}