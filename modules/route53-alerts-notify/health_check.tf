# Create a healthcheck
resource "aws_route53_health_check" "healthcheck" {
  fqdn                    = var.domain_name
  port                    = var.port
  type                    = var.type
  resource_path           = var.resource_path
  failure_threshold       = var.failure_threshold
  request_interval        = var.request_interval
  reference_name          = var.reference_name
  cloudwatch_alarm_region = "us-east-1"
  tags = var.tags
}
