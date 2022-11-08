#### Example with Terraform Module
```terraform
module "vpc-lookup" {
  source        = "path/to/vpc/lookup"
  name          = "example-vpc-dev"
  subnet_groups = ["public", "private", "data"]
  subnet_regex = {
    public  = "public-subnet-1*"
    private = "private-subnet-1*"
    data    = "private-subnet-2*"
  }
}
```

#### Example with AWS VPC Wizard
```terraform
module "vpc-lookup" {
  source        = "path/to/vpc/lookup"
  name          = "example-vpc-dev"
  subnet_groups = ["public", "private"]
  subnet_regex = {
    public  = "*-subnet-public*"
    private = "*-subnet-private*"
  }
}
```