output "id" {
  value       = join("", aws_sns_topic.default.*.id)
  description = "The ID of the SNS platform application."
}

output "arn" {
  value       = join("", aws_sns_topic.default.*.arn)
  description = "The ARN of the SNS platform application."
}
