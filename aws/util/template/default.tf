locals {
  template_path = "${path.module}/local/template.tftpl"
}

resource local_file "default" {
  filename = local.template_path
  content = var.template
}

data "local_file" "default" {
  depends_on = [local_file.default]
  filename = local.template_path
}

locals {
  rendered = templatefile(data.local_file.default.filename, var.params)
}