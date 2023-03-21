resource "kubernetes_manifest" "create_namespace" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "goldilocks"
    }
  }
}
