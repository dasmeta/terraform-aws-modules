resource "kubernetes_namespace" "namespace" {
  metadata {
    annotations = {
      name = var.namespace
    }

    # labels = {
    #   mylabel = "label-value"
    # }

    name = var.namespace
  }
}