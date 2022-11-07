### Notes
#### Reserved Environment Variables
- https://docs.aws.amazon.com/lambda/latest/dg/configuration-envvars.html#configuration-envvars-runtime

#### Example
```terraform
module "test-lambda" {
  source               = "path/to/lambda/function"
  name                 = "test-api"
}
```
