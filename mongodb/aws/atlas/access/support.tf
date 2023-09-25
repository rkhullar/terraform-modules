data "mongodbatlas_project" "default" {
  name = var.project
}

locals {
  project_id = data.mongodbatlas_project.default.id
}

data "aws_iam_roles" "admin-sso" {
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
  name_regex  = ".*AdministratorAccess.*"
}

locals {
  # aws_admin_roles = zipmap(tolist(data.aws_iam_roles.admin-sso.names), tolist(data.aws_iam_roles.admin-sso.arns))
  aws_admin_roles = { for arn in data.aws_iam_roles.admin-sso.arns : reverse(split("/", arn))[0] => arn }
}

locals {
  access_roles = toset([for rule in var.access_rules : rule.role])
}

data "aws_iam_role" "default" {
  for_each = local.access_roles
  name     = join("", compact([var.role_prefix, each.value, var.role_suffix]))
}

locals {
  aws_role_ids  = zipmap(keys(data.aws_iam_role.default), values(data.aws_iam_role.default)[*].arn)
  rules_by_role = { for role, id in local.aws_role_ids : role => [for rule in var.access_rules : rule if rule.role == role] }
}