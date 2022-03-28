terraform {
  experiments = [module_variable_optional_attrs]
}

module "custom-rules" {
  source  = "../security-group/custom-rules"
  enable  = var.enable_rules
  aliases = local.aliases
  rules   = var.custom_rules
}

output "x" {
  value = module.custom-rules
}