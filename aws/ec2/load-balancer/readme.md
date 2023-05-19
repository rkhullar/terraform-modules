#### Example
```terraform
locals {
  service_names = {
    backend = "example-backend"
  }
}

locals {
  default_response = {
    content_type = "application/json"
    message_body = jsonencode({ message = "none shall pass" })
    status_code  = 503
  }
}
```

```terraform
module "load-balancer" {
  source          = "path/to/ec2/load-balancer"
  name            = "example-load-balancer"
  internal        = false
  type            = "application"
  vpc_id          = "vpc-tbd"
  subnets         = ["subnet-tbd"]
  security_groups = ["sg-tbd"]

  target_groups = [
    { key = "backend", name = local.service_names.backend, target_type = "ip", port = 8000, protocol = "http", health_check = { path = "/", matcher = "200" } }
  ]

  listeners = [
    { port = 443, protocol = "https", cert = var.cert, action = "fixed-response", fixed_response = local.default_response },
    { port = 80, protocol = "http", action = "redirect", redirect = { protocol = "https", port = 443, status_code = "HTTP_301" } }
  ]
}
```


```terraform
resource "aws_alb_listener_rule" "backend" {
  listener_arn = module.load-balancer.listeners[443]["arn"]
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = module.load-balancer.target_groups["backend"]["arn"]
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
```