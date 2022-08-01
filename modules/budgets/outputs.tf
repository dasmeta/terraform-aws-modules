output "arn" {
  description = "The Amazon Resource Name (ARN) of the rule"
  value       = var.is_enabled ? aws_cloudwatch_event_rule.this[0].arn : null
}
