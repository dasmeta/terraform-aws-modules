locals {
  group_name = var.name

  //dummy_path has to he specified by default otherwise ingress can't be built
  dummy_path = [
    {
      name        = "response-static"
      port        = null
      path        = "/Pto48SjdzKBclyL5"
      static_port = "use-annotation"
    },
    {
      name        = "ssl-redirect"
      port        = null
      path        = "/*"
      static_port = "use-annotation"
    }
  ]

  annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name"       = var.name
    "alb.ingress.kubernetes.io/scheme"                   = var.scheme
    "alb.ingress.kubernetes.io/backend-protocol"         = var.backend_protocol
    "alb.ingress.kubernetes.io/certificate-arn"          = var.certificate_arn
    "alb.ingress.kubernetes.io/listen-ports"             = var.certificate_arn == "" ? "[{\"HTTP\":80}]" : "[{\"HTTPS\":443}, {\"HTTP\":80}]"
    "alb.ingress.kubernetes.io/actions.response-static"  = "{\"Type\": \"fixed-response\", \"FixedResponseConfig\": { \"ContentType\": \"text/plain\", \"StatusCode\": \"200\", \"MessageBody\": \"Hello!\"}}"
    "alb.ingress.kubernetes.io/actions.ssl-redirect"     = var.ssl_redirect == true ? "{\"Type\": \"redirect\", \"RedirectConfig\": { \"Protocol\": \"HTTPS\", \"Port\": \"443\", \"StatusCode\": \"HTTP_301\"}}" : ""
    "alb.ingress.kubernetes.io/group.name"               = local.group_name
    "alb.ingress.kubernetes.io/ssl-policy"               = var.ssl_policy
    "alb.ingress.kubernetes.io/success-codes"            = var.healthcheck_success_codes
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
          for_each = var.path != null ? var.path : local.dummy_path
          content {
            backend {
              service {
                name = path.value["name"]
                port {
                  number = path.value["port"]
                  name   = var.path != null ? null : path.value["static_port"]
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
