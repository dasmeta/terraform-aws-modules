output "name" {
  value = module.lambda.lambda_function_name
}

output "role_arn" {
  value = module.lambda.lambda_role_arn
}
