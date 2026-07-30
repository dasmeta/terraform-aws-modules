# SecretStore / ClusterSecretStore pointing at AWS Secrets Manager. Auth uses the controller's
# Pod Identity credentials to assume this store's role (spec.provider.aws.role) — no secretRef,
# no static keys. metadata.namespace is set only for the namespaced SecretStore kind.
resource "kubectl_manifest" "main" {
  yaml_body = yamlencode({
    apiVersion = var.external_secrets_api_version
    kind       = var.kind
    metadata = merge(
      { name = local.sanitized_name },
      var.kind == "SecretStore" ? { namespace = var.namespace } : {},
    )
    spec = {
      provider = {
        aws = {
          service = "SecretsManager"
          region  = local.region
          role    = aws_iam_role.store.arn
        }
      }
    }
  })

  depends_on = [aws_iam_role_policy_attachment.store]
}
