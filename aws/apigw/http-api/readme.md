#### Notes
By default, this module uses jwt authorization. If the api is created with jwt auth enabled, and you need to disable the
auth, then you'll run into this error message:

`ConflictException: Cannot delete authorizer {name}, is referenced in route: $default`

There is an open GitHub issue for this:
- https://github.com/hashicorp/terraform-provider-aws/issues/14812

As a workaround, you can manually detach the authorizer from the route in the AWS console.

#### Example
```terraform
module "test-api" {
  source                = "path/to/http-api"
  name                  = "test-api"
  lambda_function_name  = "test-lambda"
  lambda_function_alias = "latest" # optional
  allowed_origins       = var.allowed_origins
  jwt_auth = {
    name     = "auth.example.org"
    issuer   = "https://auth.example.org/oauth2/default"
    audience = "api://default"
  }
  extra_routes = [
    { method = "get",  path = "/docs" },
    { method = "get",  path = "/debug/auth-state", require_jwt = true },
    { method = "post", path = "/message", require_jwt = true, scopes = ["message:write"] }
  ]
}
```
