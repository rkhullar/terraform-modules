terraform {
  experiments = [module_variable_optional_attrs]
}

locals {
  names = defaults(var.names, {
    load_balancer = "load-balancer"
    linux_runtime = "linux-runtime"
    data_runtime  = "data-runtime"
  })
  descriptions = defaults(var.descriptions, {
    load_balancer = "security group for load balancer"
    linux_runtime = "security group for linux runtime"
    data_runtime  = "security group for data runtime"
  })
}