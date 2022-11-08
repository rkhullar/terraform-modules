resource "aws_lambda_function" "default" {
  function_name                  = var.name
  tags                           = var.tags
  role                           = data.aws_iam_role.default.arn
  runtime                        = var.runtime
  handler                        = var.handler
  architectures                  = [var.architecture]
  memory_size                    = var.memory
  timeout                        = var.timeout
  package_type                   = "Zip"
  publish                        = var.publish
  layers                         = var.layers
  reserved_concurrent_executions = var.reserved_concurrent_executions
  filename                       = data.archive_file.default.output_path
  source_code_hash               = data.archive_file.default.output_base64sha256

  dynamic "environment" {
    for_each = local.enable_environment ? [true] : []
    content {
      variables = local.environment
    }
  }

  dynamic "vpc_config" {
    for_each = local.enable_vpc_config ? [true] : []
    content {
      security_group_ids = var.security_groups
      subnet_ids         = var.subnets
    }
  }

  lifecycle {
    ignore_changes = [source_code_hash, layers]
  }
}

locals {
  enable_vpc_config    = var.subnets != null || var.security_groups != null
  enable_environment   = length(var.environment) > 0
  environment_all_caps = { for key, val in var.environment : replace(upper(key), "-", "_") => val }
  environment          = var.ignore_case ? var.environment : local.environment_all_caps
}

locals {
  template_languages = ["python", "nodejs"]
  # TODO: startswith added in terraform 1.3
  # _template_language = one([for language in local.template_languages : language if startswith(var.runtime, language)])
  _template_language = one(flatten([for language in local.template_languages : regexall("^${language}", var.runtime)]))
  template_language  = coalesce(local._template_language, local.template_languages[0])
}

data "aws_iam_role" "default" {
  name = var.role
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/templates/${local.template_language}/${var.template}"
  output_path = "${path.module}/local/${local.template_language}/${var.template}.zip"
}