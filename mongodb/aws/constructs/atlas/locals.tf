locals {
  common_tags = {
    account     = var.account
    project     = var.project
    owner       = var.owner
    namespace   = var.namespace
    environment = var.environment
    region      = var.region
    managed     = "terraform"
  }
}

locals {
  create_serverless = var.cluster_type == "serverless"
  create_advanced   = contains(["shared"], var.cluster_type)
}

locals {
  standard_connection = compact(local._standard_connection_list)[0]
  _standard_connection_list = [
    local.create_serverless ? mongodbatlas_serverless_instance.serverless[0].connection_strings_standard_srv : null,
    local.create_advanced ? mongodbatlas_advanced_cluster.advanced[0].connection_strings[0].standard_srv : null
  ]
}

locals {
  public_atlas_host = split("//", local.standard_connection)[1]
}