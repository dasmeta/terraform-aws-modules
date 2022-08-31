resource "kubernetes_manifest" "example_km" {

  manifest = yamldecode(file("../sso-deploy/src/role-dev.yaml"))
}


locals {
  kube_manifests_map = {
  for a in var.kube_manifests :
  format("%v-%v-%v-%v", a., substr(a.principal_type, 0, 1), a.principal_name, a.permission_set_name) => a
  }
}