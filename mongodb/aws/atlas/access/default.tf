resource "mongodbatlas_project_ip_access_list" "default" {
  for_each   = { for item in var.ingress_sources : item.source => item }
  project_id = local.atlas_project_id
  cidr_block = each.value.source
  comment    = each.value.comment
}

data "aws_iam_roles" "admin-sso" {
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
  name_regex  = ".*AdministratorAccess.*"
}

resource "mongodbatlas_database_user" "default" {
  for_each           = local.aws_role_ids
  project_id         = local.atlas_project_id
  auth_database_name = "$external"
  aws_iam_type       = upper("role")
  username           = each.value
  scopes {
    type = upper("cluster")
    name = var.atlas_cluster
  }
  dynamic "roles" {
    for_each = local.rules_by_role[each.key]
    content {
      role_name       = roles.value.access
      database_name   = roles.value.database
      collection_name = roles.value.collection
    }
  }
}