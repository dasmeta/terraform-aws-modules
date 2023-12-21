data "aws_acm_certificate" "issued" {
  domain   = "test.dasmeta.com"
  statuses = ["ISSUED"]
}

module "ingress" {
  source = "../.."

  name      = "dev"
  hostnames = ["test.dasmeta.com"]
  scheme    = "internal"
  namespace = "default"

  certificate_arn           = data.aws_acm_certificate.issued.arn
  healthcheck_path          = "/health"
  healthcheck_success_codes = "200-399"

  tls_hosts = ["test.dasmeta.com"]

  alarms = {
    sns_topic = "Default"
    # If you want overwrite existing values
    custom_values = {
      error_5xx = {
        statistic = "sum"
        threshold = "10"
        period    = "60"
      },
      response_time = {
        period    = "60"
        threshold = "10"
        statistic = "avg"
      }
    }
  }
}

output "ingress_all" {
  value       = module.ingress.ingress_all
  description = "Load Balancer All."
}
