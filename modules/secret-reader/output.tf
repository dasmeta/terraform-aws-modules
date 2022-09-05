output "secrets" {
  value = local.secrets
}

output "secret_value" {
  value = local.secrets[var.secret_key]
}
