# variables
variable "name" {
  type        = string
  description = "Route53 Zone name"
}

# outputs
output "zone_id" {
  value       = aws_route53_zone.main.zone_id
  description = "Return created zone id."
}
output "arn" {
  value       = aws_route53_zone.main.arn
  description = "Return created zone arn."
}

# resources
resource "aws_route53_zone" "main" {
  name = var.name
}
