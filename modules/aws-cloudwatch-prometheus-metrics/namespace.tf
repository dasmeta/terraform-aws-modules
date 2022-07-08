resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}
