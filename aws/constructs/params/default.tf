module "default" {
  source  = "../../params"
  tags    = local.common_tags
  prefix  = local.prefix
  managed = var.managed
  secrets = var.secrets
  custom  = var.custom
}