output "arn" {
  value       = aws_cognito_user_pool.pool.arn
  description = "AWS Cognito User Pool ARN"
}

output "clients_id" {
  value = values(tomap(aws_cognito_user_pool_client.client)).*.id
}
