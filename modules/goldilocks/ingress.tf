locals {
  auth = var.create_dashboard_ingress ? jsonencode({ "userPoolARN" = "${var.auth.userPoolARN}", "userPoolClientID" = "${var.auth.userPoolClientID}", "userPoolDomain" = "${var.auth.userPoolDomain}" }) : ""
}

module "ingress" {
  count = var.create_dashboard_ingress ? 1 : 0

  source  = "dasmeta/modules/aws//modules/ingress"
  version = "1.0.0"

  alb_name    = var.alb_name
  hostname    = var.hostname
  namespace   = "goldilocks"
  api_version = "networking/v1"
  path = [
    {
      service_name = "goldilocks-dashboard"
      service_port = "80"
      path         = "/"
    }
  ]
  default_backend = {
    service_name = "goldilocks-dashboard"
    service_port = "80"
  }
  annotations = {
    "alb.ingress.kubernetes.io/load-balancer-name" = var.alb_name
    "kubernetes.io/ingress.class"                  = "alb"
    "alb.ingress.kubernetes.io/scheme"             = "internet-facing"
    "alb.ingress.kubernetes.io/success-codes"      = "200-399"
    "alb.ingress.kubernetes.io/certificate-arn"    = var.alb_certificate_arn
    "alb.ingress.kubernetes.io/auth-type"          = "cognito"
    "alb.ingress.kubernetes.io/auth-idp-cognito"   = local.auth
    "alb.ingress.kubernetes.io/listen-ports"       = "[{\"HTTPS\":443}]"
  }

  depends_on = [
    kubernetes_manifest.create_namespace
  ]
}
