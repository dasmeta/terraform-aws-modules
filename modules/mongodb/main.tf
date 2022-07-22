resource "helm_release" "mongodb" {
  name = var.name

  chart      = "mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  version    = var.chart_version

  values = var.values != null ? var.values : [
    file("${path.module}/values-${var.setup}.yaml")
  ]

  dynamic "set" {
    iterator = item
    for_each = var.set == null ? [] : var.set

    content {
      name  = item.value.name
      value = item.value.value
    }
  }
}
