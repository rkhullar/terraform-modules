resource "auth0_role" "default" {
  name        = var.name
  description = var.description
}

locals {
  resource_server_scope_list = flatten([for key, values in var.permissions : [for value in values : { resource_server_identifier = key, scope = value }]])
  resource_server_scope_map  = { for item in local.resource_server_scope_list : "${item.resource_server_identifier}|${item.scope}" => item }
}

resource "auth0_role_permission" "default" {
  for_each                   = local.resource_server_scope_map
  role_id                    = auth0_role.default.id
  resource_server_identifier = each.value.resource_server_identifier
  permission                 = each.value.scope
}