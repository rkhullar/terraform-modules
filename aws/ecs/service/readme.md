#### Example
```terraform
module "example-service" {
  source          = "path/to/ecs/service"
  name            = local.service_names.backend
  cluster         = "cluster-name"
  launch_type     = "fargate"
  architecture    = "arm64"
  subnets         = ["subnet-tbd"]
  security_groups = ["sg-tbd"]
  target_group    = module.load-balancer.target_groups["example"]["arn"]
  capacity        = { min = 2, max = 4 }
  autoscaling     = { metric = "ALBRequestCountPerTarget", target = 50, resource_label = module.load-balancer.resource_labels["example"] }
  capacity_providers = [
    { name = "fargate", weight = 1, base = 1 },
    { name = "fargate-spot", weight = 4 }
  ]
  task_config = {
    roles  = { task = module.task-role.output["arn"], exec = module.task-role.output["arn"] }
    ports  = [8000]
    sizing = { task = { cpu = 256, memory = 512 } }
    environment = {
      atlas-host = "example.tbd.mongodb.net"
    }
    secrets = {
      api-key = "param-store-arn"
    }
  }
}
```
