resource "kubernetes_deployment" "example" {

  depends_on = [
    kubectl_manifest.prometheus_config,
    kubectl_manifest.cwagentconfig
  ]
  metadata {
    name      = "cwagent-prometheus"
    namespace = var.namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "cwagent-prometheus"
      }
    }

    template {
      metadata {
        labels = {
          app = "cwagent-prometheus"
        }
      }

      spec {
        termination_grace_period_seconds = 60
        service_account_name             = "cwagent-prometheus"
        container {
          image = "amazon/cloudwatch-agent:1.247352.0b251908"
          name  = "cloudwatch-agent"

          resources {
            limits = {
              cpu    = "1000m"
              memory = "1000Mi"
            }
            requests = {
              cpu    = "200m"
              memory = "200Mi"
            }
          }
          env {
            name  = "CI_VERSION"
            value = "k8s/1.3.10"
          }
          volume_mount {
            name       = "prometheus-cwagentconfig"
            mount_path = "/etc/cwagentconfig"
          }
          volume_mount {
            name       = "prometheus-config"
            mount_path = "/etc/prometheusconfig"

          }
        }
        volume {
          name = "prometheus-cwagentconfig"
          config_map {
            name = "prometheus-cwagentconfig"
          }
        }

        volume {
          name = "prometheus-config"
          config_map {
            name = "prometheus-config"
          }
        }
      }
    }
  }
}
