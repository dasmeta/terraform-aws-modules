resource "kubectl_manifest" "test" {
    yaml_body = templatefile("${path.module}/secret-store.tmpl", {
      name = var.name
      region = var.region
      controller = var.controller
    })
}
