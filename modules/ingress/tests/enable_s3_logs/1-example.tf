data "aws_acm_certificate" "issued" {
  domain   = "test.dasmeta.com"
  statuses = ["ISSUED"]
}

module "ingress" {
  source = "../.."

  name      = "dev"
  hostname  = "test.dasmeta.com"
  scheme    = "internal"
  namespace = "default"

  enable_send_alb_logs_to_cloudwatch = false
  enable_send_alb_logs_to_s3         = true

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = ["test.dasmeta.com"]

  alarms = {
    sns_topic = "Default"
  }
}

output "ingress_all" {
  value       = module.ingress.ingress_all
  description = "Load Balancer All."
}
