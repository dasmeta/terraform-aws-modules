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


resource "kubernetes_ingress" "product_ingress" {
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
