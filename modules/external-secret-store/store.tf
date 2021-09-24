resource "kubectl_manifest" "main" {
  yaml_body = templatefile("${path.module}/secret-store.tmpl", {
    name = var.name
    region = data.aws_region.current.name
    controller = var.controller
  })

  depends_on = [
    module.iam-user
  ]
}
