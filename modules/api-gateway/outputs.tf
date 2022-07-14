output "id" {
  value       = aws_api_gateway_rest_api.this.id
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.this.*.execution_arn
  description = "The Execution ARN of the REST API."
}

output "access_key_id" {
  description = "The access key ID"
  value       = module.api_iam_user.iam_access_key_id
}

output "access_secret_key" {
  description = "The access key secret"
  value       = module.api_iam_user.iam_access_key_secret
  sensitive   = true
}

output "access_secret_key_encrypted" {
  description = "The access key secret with pgp encryption"
  value       = module.api_iam_user.iam_access_key_encrypted_secret
}
