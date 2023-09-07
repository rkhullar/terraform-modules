#### Example
```terraform
module "test-api" {
  source                = "path/to/rest-api"
  name                  = "test-api"
  lambda_function_name  = "test-lambda"
  lambda_function_alias = "latest" # optional
  routes = [
    { method = "get",    path = "/{proxy+}", require_api_key = true },
    { method = "post",   path = "/{proxy+}", require_api_key = true },
    { method = "put",    path = "/{proxy+}", require_api_key = true },
    { method = "delete", path = "/{proxy+}", require_api_key = true }
  ]
}
```