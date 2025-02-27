output "secrets" {
  value     = local.secrets
  sensitive = true
}

output "secret_value" {
  value     = try(local.secrets[var.secret_key], null)
  sensitive = true
}
