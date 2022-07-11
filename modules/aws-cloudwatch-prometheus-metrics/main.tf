data "aws_caller_identity" "current" {}

resource "helm_release" "aws-cloudwatch-metrics" {
  name       = "cloudwatch-agent-prometheus"
  repository = "https://dasmeta.github.io/helm"
  # chart = "${path.module}/../helm"
  chart     = "cloudwatch-agent-prometheus"
  version   = "0.0.1"
  namespace = var.namespace

  #   values = [
  #     file("${path.module}/values.yaml")
  #   ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = "cloudwatch-agent-prometheus"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-cloudwatch-metrics-role.name}"
  }

  depends_on = [
    kubernetes_namespace.namespace
  ]
}
