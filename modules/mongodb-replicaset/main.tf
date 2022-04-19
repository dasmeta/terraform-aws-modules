resource "helm_release" "mongodb" {
  name = "mongodb"

  chart      = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"

  values = [
    file("${path.module}/values-${var.setup}.yaml")
  ]

  set {
    name  = "some.value"
    value = "true"
  }
}