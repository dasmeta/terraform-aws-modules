locals {
  default_annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name" = "${var.alb_name}"
    "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
    "alb.ingress.kubernetes.io/backend-protocol"   = "HTTP"
    "alb.ingress.kubernetes.io/group.name"         = "${var.alb_name}-group"
    "kubernetes.io/ingress.class"                  = "alb"
    "alb.ingress.kubernetes.io/subnets"            = "subnet-04ac494312f18be96, subnet-08b3280d7f803a9ea, subnet-0a3512a8c86c94c1d"
  }
  annotations = var.annotations == {} ? local.default_annotations : var.annotations
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
