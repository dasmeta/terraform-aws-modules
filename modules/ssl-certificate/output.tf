output "arn" {
  value       = aws_acm_certificate.main.arn
  sensitive   = false
  description = "SSL Certificate ARN to be used in ingress controllers"
}

output "cname_records" {
  value = aws_acm_certificate.main.domain_validation_options
}
