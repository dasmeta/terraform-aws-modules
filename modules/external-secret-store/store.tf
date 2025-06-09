resource "kubectl_manifest" "main" {
  yaml_body = templatefile("${path.module}/secret-store.tmpl", {
    name                      = local.sanitized-name
    kind                      = var.kind
    namespace                 = var.namespace
    region                    = data.aws_region.current.name
    controller                = var.controller
    externalSecretsApiVersion = var.external_secrets_api_version
  })

  depends_on = [
    module.iam-user
  ]
}
