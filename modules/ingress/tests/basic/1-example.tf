data "aws_acm_certificate" "issued" {
  domain   = "*.devops.dasmeta.com"
  statuses = ["ISSUED"]
}


module "ingress" {
  source = "../.."

  name      = "dev"
  hostname  = "*.devops.dasmeta.com"
  scheme    = "internal"
  namespace = "nginx"

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = ["*.devops.dasmeta.com"]
}
