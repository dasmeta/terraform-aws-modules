resource "kubernetes_role_v1" "k8s-rbac" {

  for_each = { for kr in local.role_binding : kr.name => kr }

  metadata {
    name      = each.key
    namespace = each.value.namespace
  }

  rule {
    api_groups     = ["apps"]
    resources      = each.value.resources
    verbs          = each.value.actions
  }
}
