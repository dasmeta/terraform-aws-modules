output "zone_id" {
  value       = var.create_zone ? module.zone[0].zone_id : data.aws_route53_zone.main[0].zone_id
  description = "Returns zone id."
}
output "arn" {
  value       = var.create_zone ? module.zone[0].arn : data.aws_route53_zone.main[0].arn
  description = "Returns zone arn."
}
