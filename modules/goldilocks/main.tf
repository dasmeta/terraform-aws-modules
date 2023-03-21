resource "helm_release" "vpa" {
  count      = var.create_vpa_server ? 1 : 0
  name       = "goldilocks"
  version    = "1.6.1"
  repository = "https://charts.fairwinds.com/stable"
  chart      = "vpa"
}


resource "null_resource" "vpa_configure" {
  for_each = var.namespaces

  provisioner "local-exec" {
    command = "kubectl label ns ${each.value} goldilocks.fairwinds.com/enabled=true --overwrite"
  }
  depends_on = [
    kubernetes_manifest.create_namespace
  ]
}

resource "helm_release" "goldilocks_deploy" {
  name = "goldilocks"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "goldilocks"
  namespace  = "goldilocks"

  set {
    name  = "dashboard.service.type"
    value = "NodePort"
  }
  depends_on = [
    kubernetes_manifest.create_namespace
  ]
}
