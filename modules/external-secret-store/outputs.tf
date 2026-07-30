output "store_role_arn" {
  description = "ARN of the per-store IAM role the controller assumes for this store."
  value       = aws_iam_role.store.arn
}

output "name" {
  description = "Sanitized SecretStore/ClusterSecretStore resource name."
  value       = local.sanitized_name
}

output "kind" {
  description = "Store kind (SecretStore or ClusterSecretStore)."
  value       = var.kind
}
