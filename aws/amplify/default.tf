terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  create_role = var.create_role && var.role == null
  role_arn    = local.create_role ? module.role[0].output["arn"] : var.role
}

module "role" {
  count      = local.create_role ? 1 : 0
  source     = "github.com/rkhullar/terraform-modules//aws/iam/role?ref=0.1.0"
  name       = var.name
  principals = [{ type = "Service", identifiers = ["amplify.amazonaws.com"] }]
  managed_policies = [
    "AdministratorAccess-Amplify"
  ]
}

locals {
  variables        = { for key, val in local.merged_variables : upper(key) => val }
  merged_variables = merge({ _live_updates = local._live_updates }, var.environment_variables)
  _live_updates = jsonencode([{
    name    = "Next.js version"
    pkg     = "next-version"
    type    = "internal"
    version = "latest"
  }])
}

resource "aws_amplify_app" "default" {
  name                  = var.name
  tags                  = var.tags
  repository            = var.repository
  build_spec            = var.build_spec
  access_token          = var.access_token
  iam_service_role_arn  = local.role_arn
  platform              = "WEB_DYNAMIC"
  environment_variables = local.variables

  dynamic "custom_rule" {
    for_each = var.enable_rules ? var.rules : []
    content {
      status = custom_rule.value.status
      source = custom_rule.value.source
      target = custom_rule.value.target
    }
  }
}

locals {
  branch_map  = { for branch in local.branch_list : branch.name => branch }
  branch_list = [for branch in var.branches : merge(local.branch_default, branch)]
  branch_default = {
    auto_build = false
    basic_auth = false
    preview    = false
    variables  = {}
  }
}

resource "aws_amplify_branch" "default" {
  for_each                    = local.branch_map
  framework                   = "Next.js - SSR"
  app_id                      = aws_amplify_app.default.id
  branch_name                 = each.key
  tags                        = var.tags
  stage                       = upper(each.value.stage)
  environment_variables       = { for key, val in each.value.variables : upper(key) => val }
  enable_auto_build           = each.value.auto_build
  enable_basic_auth           = each.value.basic_auth
  enable_pull_request_preview = each.value.preview
}