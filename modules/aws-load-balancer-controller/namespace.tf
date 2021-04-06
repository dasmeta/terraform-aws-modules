resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0

  metadata {
    annotations = {
      name = var.namespace
    }

    name = var.namespace
  }
}