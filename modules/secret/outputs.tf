output "secret_id" {
  value       = aws_secretsmanager_secret.secret.id
  description = "The ID of created secret"
}
