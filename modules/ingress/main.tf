locals {
  group_name = "${var.name}-group"
  default_path = [{
    service_name        = "response-static"
    service_port_number = null
    path                = "/Pto48SjdzKBclyL5"
  }]
  service_port_name = "use-annotation"

  annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name"       = var.name
    "alb.ingress.kubernetes.io/scheme"                   = var.scheme
    "alb.ingress.kubernetes.io/backend-protocol"         = var.backend_protocol
    "alb.ingress.kubernetes.io/certificate-arn"          = var.certificate_arn
    "alb.ingress.kubernetes.io/listen-ports"             = var.certificate_arn == "" ? var.listen_ports : "[{\"HTTPS\":443}, {\"HTTP\":80}]"
    "alb.ingress.kubernetes.io/actions.response-static"  = "{\"Type\": \"fixed-response\", \"FixedResponseConfig\": { \"ContentType\": \"text/plain\", \"StatusCode\": \"200\", \"MessageBody\": \"Hello!\"}}"
    "alb.ingress.kubernetes.io/actions.ssl-redirect"     = var.ssl_redirect == true ? "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}" : ""
    "alb.ingress.kubernetes.io/group.name"               = local.group_name
    "alb.ingress.kubernetes.io/ssl-policy"               = var.ssl_policy
    "alb.ingress.kubernetes.io/success-codes"            = var.success_codes
    "alb.ingress.kubernetes.io/load-balancer-attributes" = var.load_balancer_attributes
    "alb.ingress.kubernetes.io/healthcheck-path"         = var.healthcheck_path
    "kubernetes.io/ingress.class"                        = "alb"
  }
}

# for apiVersion: networking.k8s.io/v1
resource "kubernetes_ingress_v1" "this_v1" {
  metadata {
    name        = var.name
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
          for_each = var.path != null ? var.path : local.default_path
          content {
            backend {
              service {
                name = path.value["service_name"]
                port {
                  number = path.value["service_port_number"]
                  name   = var.path != null ? null : local.service_port_name
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
