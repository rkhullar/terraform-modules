### Notes

#### Lifecycle
Ths module creates the lambda function resource using hello world templates for either python or nodejs. After first
provision, changes to the function code and layer integrations are ignores. All the other configuration like environment
variables and the handler are tracked with terraform.

#### Reserved Environment Variables
- https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-runtime

#### Example
```terraform
module "test-lambda" {
  source          = "path/to/lambda/function"
  name            = "example-python-lambda"
  role            = "basic-vpc-lambda-role"
  runtime         = "python3.9"
  handler         = "lambda_function.lambda_handler"
  architecture    = "arm64"
  layers          = []
  subnets         = ["subnet-tbd"]
  security_groups = ["sg-tbd"]
  environment = {
    atlas_host = "test-pe-0.example.mongodb.net"
  }
}
```
