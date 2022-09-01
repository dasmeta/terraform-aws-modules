resource "kubernetes_role_v1" "k8s-rbac" {

  for_each = { for kr in var.rbac_rule : kr.name => ps }

  metadata {
    name      = each.key
    namespace = each.value.namespace
    labels = {
      test = "MyRole"
    }
  }

  rule {
    api_groups     = try(each.value.api_groups, "")
    resources      = each.value.resources
    resource_names = each.value.resource_names
    verbs          = each.value.verbs
  }
}
