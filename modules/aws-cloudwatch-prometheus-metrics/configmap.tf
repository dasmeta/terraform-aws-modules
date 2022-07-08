data "kubectl_path_documents" "prometheus_config" {
  pattern = "${path.module}/prometheus_config.yml"
  vars = {
    namespace = var.namespace
  }
}

data "kubectl_path_documents" "cwagentconfig" {
  pattern = "${path.module}/prometheus_cwagentconfig.yml"
  vars = {
    namespace    = var.namespace
    region       = data.aws_region.current.name
    cluster_name = var.cluster_name
  }
}

resource "kubectl_manifest" "prometheus_config" {
  count     = length(data.kubectl_path_documents.prometheus_config.documents)
  yaml_body = element(data.kubectl_path_documents.prometheus_config.documents, count.index)
}

resource "kubectl_manifest" "cwagentconfig" {
  count     = length(data.kubectl_path_documents.cwagentconfig.documents)
  yaml_body = element(data.kubectl_path_documents.cwagentconfig.documents, count.index)
}

# data "kubectl_path_documents" "cwagentconfig" {
#   pattern = "${path.module}/prometheus_cwagentconfig.json"
#   vars = {
#     region       = data.aws_region.current.name
#     cluster_name = var.cluster_name
#   }
# }

# resource "kubernetes_config_map_v1" "prometheus-config" {
#   metadata {
#     name      = "prometheus-config"
#     namespace = var.namespace
#   }

#   data = {
#     "prometheus.yaml" = "${file("${path.module}/prometheus_config.yml")}"
#   }
# }

# resource "kubernetes_config_map_v1" "prometheus-cwagentconfig" {
#   metadata {
#     name      = "prometheus-cwagentconfig"
#     namespace = var.namespace
#   }

#   data = {
#     "cwagentconfig.json" = "${data.kubectl_path_documents.cwagentconfig.documents}"
#   }
# }
