resource "mongodbatlas_database_user" "admin-sso" {
  depends_on = [data.aws_iam_roles.admin-sso]
  for_each           = var.create_admin ? local.aws_admin_roles : {}
  project_id         = local.project_id
  auth_database_name = "$external"
  aws_iam_type       = upper("role")
  username           = each.value
  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}

resource "mongodbatlas_database_user" "default" {
  for_each           = local.aws_role_ids
  project_id         = local.project_id
  auth_database_name = "$external"
  aws_iam_type       = upper("role")
  username           = each.value
  scopes {
    type = upper("cluster")
    name = var.cluster
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

resource "mongodbatlas_project_ip_access_list" "default" {
  for_each   = { for item in var.ingress_sources : item.source => item }
  project_id = local.project_id
  cidr_block = each.value.source
  comment    = each.value.comment
}