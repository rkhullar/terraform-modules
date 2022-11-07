locals {
  reserved_environment_keys = ["-handler", "aws-region", "aws-execution-env", "aws-lambda-function-name", "aws-lambda-function-memory-size", "aws-lambda-function-version", "aws-lambda-log-stream-name", "aws-access-key-id", "aws-secret-access-key", "aws-session-token", "tz", "lambda-task-root", "lambda-runtime-dir"]
}

data "aws_iam_role" "default" {
  name = var.role
}

resource "aws_lambda_function" "default" {
  function_name                  = var.name
  handler                        = var.handler
  role                           = data.aws_iam_role.default.arn
  runtime                        = var.runtime
  memory_size                    = var.memory
  timeout                        = var.timeout
  architectures                  = ["arm64"]
  package_type                   = "Zip"
  publish                        = false
  filename                       = data.archive_file.lambda_template_zip.output_path
  source_code_hash               = data.archive_file.lambda_template_zip.output_base64sha256
  tags                           = var.tags
  layers                         = var.layers
  reserved_concurrent_executions = var.reserved_concurrent_executions

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
    ignore_changes = [source_code_hash, last_modified, filename, layers]
    # ignore_changes = [source_code_hash, last_modified, filename, layers]
  }
}