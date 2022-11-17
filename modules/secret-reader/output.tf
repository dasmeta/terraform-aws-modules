output "secrets" {
  value = local.secrets
}

output "secret_value" {
  value = try(local.secrets[var.secret_key], null)
}
