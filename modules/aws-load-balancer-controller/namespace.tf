# resource "kubernetes_namespace" "namespace" {
#   metadata {
#     annotations = {
#       name = var.namespace
#     }

#     name = var.namespace
#   }
# }