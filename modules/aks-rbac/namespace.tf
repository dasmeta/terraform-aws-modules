resource "kubernetes_namespace" "example" {

  for_each = { for kr in local.role_binding : kr.name => kr }

  metadata {
    annotations = {
      name = each.value.namespace
    }

    name = each.value.namespace
  }
}
