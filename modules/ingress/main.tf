locals {
  group_name = "${var.alb_name}-group"
  default_annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
    "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
    "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
    "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTPS\":443}, {\"HTTPS\":80}]"
    "alb.ingress.kubernetes.io/group.name"         = local.group_name
    "kubernetes.io/ingress.class"                  = "alb"

  }
  annotations = merge(local.default_annotations, var.annotations)
}

# for apiVersion: networking.k8s.io/v1
resource "kubernetes_ingress_v1" "this_v1" {
  count = var.api_version == "networking/v1" ? 1 : 0

  metadata {
    name        = var.alb_name
    annotations = local.annotations
  }

  spec {
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
                  number = path.value["service_port"]
                }
              }
            }
            path = path.value["path"]
          }
        }

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
  }

  spec {
    rule {
      host = var.hostname
      http {

        dynamic "path" {
          for_each = var.path
          content {
            backend {
              service_name = path.value["service_name"]
              service_port = path.value["service_port"]
            }
            path = path.value["path"]
          }
        }

      }
    }
  }
}
