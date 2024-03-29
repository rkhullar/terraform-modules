resource "aws_lambda_layer_version" "default" {
  layer_name               = var.name
  compatible_runtimes      = var.runtimes
  compatible_architectures = var.architectures
  filename                 = data.archive_file.default.output_path
  description              = var.description
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/templates/${var.template}"
  output_path = "${path.module}/local/${var.template}.zip"
}