resource "helm_release" "aws-cloudwatch-metrics" {
  name       = "aws-cloudwatch-metrics"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-cloudwatch-metrics"
  version    = "0.0.4"
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "containerdSockPath"
    value = var.containerdSockPath
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-cloudwatch-metrics"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.aws-cloudwatch-metrics-role.name}"
  }
  depends_on = [
    kubernetes_namespace.namespace
  ]
}

resource "helm_release" "aws-cloudwatch-metrics-prometheus" {
  count = var.enable_prometheus_metrics ? 1 : 0

  name       = "cloudwatch-agent-prometheus"
  repository = "https://dasmeta.github.io/helm"
  chart      = "cloudwatch-agent-prometheus"
  version    = "0.0.1"
  namespace  = var.namespace

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "region"
    value = data.aws_region.current.name
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
