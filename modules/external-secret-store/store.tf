resource "kubectl_manifest" "main" {
  yaml_body = templatefile("${path.module}/secret-store.tmpl", {
    name = var.name
    region = data.aws_region.current.name
    controller = var.controller
    arn = var.create_user ? "external-secrets-access-policy-for-store-${var.name}" : var.aws_role_arn
  })
}
