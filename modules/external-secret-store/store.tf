resource "kubectl_manifest" "main" {
  yaml_body = templatefile("${path.module}/secret-store.tmpl", {
    name = local.sanitized-name
    region = data.aws_region.current.name
    controller = var.controller
  })

  depends_on = [
    module.iam-user
  ]
}
