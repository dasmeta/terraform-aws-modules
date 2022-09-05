resource "kubernetes_role_binding" "example" {

  for_each = { for kr in local.role_binding : kr.name => kr }

  metadata {
    name      = each.key
    namespace = each.value.namespace
  }

  subject {
    kind      = "Group"          #Kind - User/Group
    name      = each.value.group #Group/User to bind
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"          # kind - Role/ClusterRole Role
    name      = each.value.name # Role/ClusterRole name dev-viewers
  }
}
