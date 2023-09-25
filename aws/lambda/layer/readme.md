#### Example
```terraform
module "test-lambda-layer" {
  source        = "path/to/lambda/layer"
  name          = "test-lambda-layer"
  runtimes      = ["python3.11"]
  architectures = ["arm64"]
}
```
