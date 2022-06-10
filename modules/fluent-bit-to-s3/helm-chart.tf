resource "helm_release" "fluent-bit" {
  name       = local.fluent_name
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  version    = "0.20.1"
  namespace  = var.namespace

  values = [
    # file("${path.module}/values.yaml")
    templatefile("${path.module}/values.yaml", {
      bucket_name = local.bucket_name,
      region      = local.region
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

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.fluent-bit.name}"
  }
}
