resource "helm_release" "fluent-bit" {
  name       = local.fluent_name
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.20.1"
  namespace  = var.namespace

  values = [
    # file("${path.module}/values.yaml")
    templatefile("${path.module}/values.yaml", {
      bucket_name    = local.bucket_name,
      region         = local.region,
      aws_secret_key = var.aws_secret_key,
      aws_access_key = var.aws_access_key
    })
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "fluent-bit"
  }
}
