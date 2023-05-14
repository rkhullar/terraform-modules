#### Example
```terraform
module "cluster" {
  source                  = "path/to/ecs/fargate"
  name                    = "cluster-name"
  capacity_providers      = [{ name = "fargate" }, { name = "fargate-spot" }]
  enable_default_strategy = false
}
```
