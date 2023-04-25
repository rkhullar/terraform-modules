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
  source          = "path/to/ecs/task-def"
}
```

[tf-ref]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
[cf-ref]: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ecs-taskdefinition-containerdefinition.html
