module "default" {
  source = "../../ec2/vpc"
  cidr = var.cidr
}