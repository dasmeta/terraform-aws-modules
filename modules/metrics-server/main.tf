resource "helm_release" "metrics_server" {
  name       = var.name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "6.0.5"
  namespace  = "kube-system"

  values = [
    file("${path.module}/values.yaml")
  ]
}
