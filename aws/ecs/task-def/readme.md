### Notes
- [Terraform Reference][tf-ref]
- [CloudFormation Reference][cf-ref]

#### TODO
- [ ] test bind mount volume
- [ ] test docker volume
- [ ] test efs volume

#### Example
```terraform
module "test-ecs-task-def" {
  source       = "path/to/ecs/task-def"
  family       = "example-service"
  tags         = local.common_tags
  roles        = { exec = "role-arn-tbd" }
  launch_types = ["fargate"]
  architecture = "arm64"
  image        = "public.ecr.aws/docker/library/python:3.10-bullseye"
  entrypoint   = ["sh", "-c"]
  command      = ["pip install flask; python {flask service code}"]
  logging      = { group = aws_cloudwatch_log_group.default-task-def.name }
  sizing       = { task = { cpu = 256, memory = 512 }, container = {} }
}
```

[tf-ref]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
[cf-ref]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-containerdefinition.html
