resource "auth0_resource_server" "default" {
  name                                            = var.name
  identifier                                      = var.identifier
  signing_alg                                     = "RS256"
  token_dialect                                   = local.token_dialect
  enforce_policies                                = var.flags.enable_rbac
  allow_offline_access                            = var.flags.allow_offline_access
  skip_consent_for_verifiable_first_party_clients = var.flags.skip_user_consent
}

locals {
  token_dialect = var.flags.include_permissions && var.flags.enable_rbac ? "access_token_authz" : "access_token"
}

resource "auth0_resource_server_scopes" "default" {
  resource_server_identifier = auth0_resource_server.default.identifier
  dynamic "scopes" {
    for_each = var.scopes
    content {
      name        = scopes.key
      description = scopes.value
    }
  }
}

locals {
  role_map = { for role in var.roles : role.name => role }
}

module "roles" {
  source      = "../role"
  for_each    = local.role_map
  name        = "${var.name}/each.value.name"
  description = each.value.description
  permissions = { auth0_resource_server.default.identifier = each.value.scopes }
}