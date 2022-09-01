resource "kubernetes_role_binding" "example" {

  for_each = { for krb in var.rbac_role_binding : krb.rolebinding_name => krb }

  metadata {
    name = each.key
    namespace = each.value.namespace
  }

  subject {
    kind      = each.value.role_kind
    name      = each.value.group_name
    api_group = try (each.value.api_group, "")
  }

  role_ref {
    api_group = each.value.api_groups
    kind      = each.value.role_kind
    name      = each.value.rolename
  }

}