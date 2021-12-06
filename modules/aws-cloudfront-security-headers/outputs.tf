output "lambda_arn" {
  value = aws_lambda_function.this.qualified_arn
}
output "custom_headers" {
  value = local.custom_headers
}
