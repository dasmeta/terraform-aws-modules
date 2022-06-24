output "id" {
  value       = join("", aws_api_gateway_rest_api.api-gateway.id)
  description = "The ID of the REST API."
}

output "execution_arn" {
  value       = join("", aws_api_gateway_rest_api.api-gateway.*.execution_arn)
  description = "The Execution ARN of the REST API."
}



