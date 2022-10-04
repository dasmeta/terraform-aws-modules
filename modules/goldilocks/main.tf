locals {
  auth = jsonencode({ "userPoolARN" = "${var.auth.userPoolARN}", "userPoolClientID" = "${var.auth.userPoolClientID}", "userPoolDomain" = "${var.auth.userPoolDomain}" })
}

resource "helm_release" "vpa" {
  count      = var.create_vpa_server ? 1 : 0
  name       = "goldilocks"
  version    = "0.5.0"
  repository = "https://charts.fairwinds.com/stable"
  chart      = "vpa"
}

resource "helm_release" "metric_server" {
  count      = var.create_metric_server ? 1 : 0
  name       = "metrics-server"
  version    = "5.8.5"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}

resource "kubernetes_manifest" "create_namespace" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Namespace"
    "metadata" = {
      "name" = "goldilocks"
    }
  }
}

resource "null_resource" "vpa_configure" {
  for_each = var.namespaces

  provisioner "local-exec" {
    command = "kubectl label ns ${each.value} goldilocks.fairwinds.com/enabled=true --overwrite"
  }
  depends_on = [
    kubernetes_manifest.create_namespace
  ]
}

resource "helm_release" "goldilocks_deploy" {
  name = "goldilocks"

  repository = "https://charts.fairwinds.com/stable"
  chart      = "goldilocks"
  namespace  = "goldilocks"

  set {
    name  = "dashboard.service.type"
    value = "NodePort"
  }
  depends_on = [
    kubernetes_manifest.create_namespace
  ]
}

module "ingress" {
  count   = var.create_dashboard_ingress ? 1 : 0
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
