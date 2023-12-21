data "aws_acm_certificate" "issued" {
  domain   = "test.dasmeta.com"
  statuses = ["ISSUED"]
}

module "this" {
  source = "../.."

  name      = "test"
  hostnames = ["test.dasmeta.com", "*.test.dasmeta.com"]

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"
  tls_hosts                 = ["test.dasmeta.com", "*.test.dasmeta.com"]

  alarms = {
    enabled   = false
    sns_topic = ""
  }
}
