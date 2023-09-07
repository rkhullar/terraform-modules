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
  source               = "path/to/http-api"
  name                 = "test-api"
  lambda_function_name = "test-lambda"
  jwt_auth = {
    issuer   = var.jwt_auth.issuer
    audience = var.jwt_auth.audience
  }
  flags = {
    create_lambda_permission = false
    enable_jwt_authorizer    = true
  }
}
```
