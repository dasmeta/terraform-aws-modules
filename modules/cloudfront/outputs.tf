output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.main.hosted_zone_id
  description = "CDN hosted zone id to be aliasd in Route53 or used somewhere else."
}

output "domain_name" {
  value       = aws_cloudfront_distribution.main.domain_name
  description = "CDN domain name to be aliasd in Route53 or used somewhere else."
}
