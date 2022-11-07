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
    for_each = local.enable_environment
    content {
      variables = local.environment
    }
  }

  dynamic "vpc_config" {
    for_each = local.enable_vpc_config
    content {
      security_group_ids = var.security_groups
      subnet_ids         = var.subnets
    }
  }

  lifecycle {
    ignore_changes = [source_code_hash]
    # ignore_changes = [source_code_hash, last_modified, filename, layers]
  }
}

locals {
  enable_vpc_config     = var.subnets != null || var.security_groups != null
  template_languages    = ["python", "nodejs"]
  template_language     = one([for language in local.template_languages : language if startswith(var.runtime, language)])
  template_source_parts = compact([path.module, "templates", local.template_language, var.template])
  template_output_parts = compact([path.module, "local", local.template_language, "${var.template}.zip"])
}

data "aws_iam_role" "default" {
  name = var.role
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = join("/", local.template_source_parts)
  output_path = join("/", local.template_output_parts)
}