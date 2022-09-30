locals {
  group_name = "${var.alb_name}-group"
  default_annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name"   = var.alb_name
    "alb.ingress.kubernetes.io/scheme"               = "internet-facing"
    "alb.ingress.kubernetes.io/backend-protocol"     = "HTTP"
    "alb.ingress.kubernetes.io/listen-ports"         = "[{\"HTTPS\":443}, {\"HTTP\":80}]"
    "alb.ingress.kubernetes.io/actions.response-200" = "{\"Type\": \"fixed-response\", \"FixedResponseConfig\": { \"ContentType\": \"text/plain\", \"StatusCode\": \"200\", \"MessageBody\": \"Hello!\"}}"
    "alb.ingress.kubernetes.io/group.name"           = local.group_name
    "kubernetes.io/ingress.class"                    = "alb"
  }
  annotations = merge(local.default_annotations, var.annotations)
}

# for apiVersion: networking.k8s.io/v1
resource "kubernetes_ingress_v1" "this_v1" {
  count = var.api_version == "networking/v1" ? 1 : 0

  metadata {
    name        = var.alb_name
    annotations = local.annotations
    namespace   = var.namespace
  }

  spec {
    dynamic "default_backend" {
      for_each = (var.default_backend.service_name != null && var.default_backend.service_port != null) ? [1] : []

      content {
        service {
          name = var.default_backend.service_name
          port {
            number = var.default_backend.service_port
          }
        }
      }
    }
    rule {
      host = var.hostname
      http {

        dynamic "path" {
          for_each = var.path
          content {
            backend {
              service {
                name = path.value["service_name"]
                port {
                  number = path.value["service_port_number"]
                  name   = path.value["service_port_name"]
                }
              }
            }
            path = path.value["path"]
          }
        }
      }
    }
    dynamic "tls" {
      for_each = var.tls_hosts != null ? [var.tls_hosts] : []

      content {
        hosts = var.tls_hosts
      }
    }
  }
}

# for apiVersion: extensions/v1beta1
resource "kubernetes_ingress" "this" {
  count = var.api_version == "extensions/v1beta1" ? 1 : 0

  metadata {
    name        = var.alb_name
    annotations = local.annotations
    namespace   = var.namespace
  }

  spec {
    backend {
      service_name = var.default_backend.service_name
      service_port = var.default_backend.service_port
    }
    rule {
      host = var.hostname
      http {

        dynamic "path" {
          for_each = var.path
          content {
            backend {
              service_name = path.value["service_name"]
              service_port = path.value["service_port_number"]
            }
            path = path.value["path"]
          }
        }

      }
    }
  }
}
