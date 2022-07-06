output "id" {
  value       = aws_api_gateway_rest_api.api-gateway.id
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.api-gateway.*.execution_arn
  description = "The Execution ARN of the REST API."
}

output "access_key_id" {
  value = try(aws_iam_access_key.api-gw-ak[0].id, "")
}

output "access_secret_key" {
  value     = try(var.pgp_key != "" ? aws_iam_access_key.api-gw-ak[0].encrypted_secret : aws_iam_access_key.api-gw-ak[0].secret, "")
  sensitive = true
}
