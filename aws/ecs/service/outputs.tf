output default {
  value = aws_ecs_service.default
}

output docker-repo {
  value = local.enable_ecr ? aws_ecr_repository.default[0].name : null
}

output container {
  value = {
    default = module.default-task-def.container
    target  = module.target-task-def.container
  }
}

output task-def {
  value = {
    default = module.default-task-def.default.*
    target  = module.target-task-def.default.*
  }
}