data "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  depends_on = [
    kubernetes_ingress_v1.this_v1
  ]
}
