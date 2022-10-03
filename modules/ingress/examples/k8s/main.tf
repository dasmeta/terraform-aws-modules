locals {
  name   = "test-ingress"
  domain = "dasmeta.com"
}

data "aws_acm_certificate" "issued" {
  domain   = "dasmeta.com"
  statuses = ["ISSUED"]
}

module "ingress" {
  source = "../.."

  name     = local.name
  hostname = local.domain

  certificate_arn           = data.aws_acm_certificate.issued.arn
  ssl_policy                = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = [local.domain]
}
