resource "kubernetes_role_binding" "example" {

  for_each = { for krb in var.rbac_role_binding : krb.rolebinding_name => krb }

  metadata {
    name      = each.key
    namespace = each.value.namespace
  }

  subject {
    kind      = each.value.principal_kind #Kind - User/Group
    name      = each.value.group_name     #Group/User to bind
    api_group = each.value.api_groups
  }

  role_ref {
    api_group = each.value.api_groups
    kind      = each.value.role_kind # kind - Role/ClusterRole Role
    name      = each.value.role_name # Role/ClusterRole name dev-viewers
  }
}
