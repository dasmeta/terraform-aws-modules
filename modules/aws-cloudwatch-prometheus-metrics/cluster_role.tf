resource "kubernetes_cluster_role" "cwagent-prometheus-role" {
  metadata {
    name = "cwagent-prometheus-role"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    non_resource_urls = ["/metrics"]
    verbs             = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "cwagent-prometheus-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cwagent-prometheus-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "cwagent-prometheus"
    namespace = var.namespace
  }
}
