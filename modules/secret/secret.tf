resource "aws_secretsmanager_secret" "secret" {
  name                    = var.name
  recovery_window_in_days = var.recovery_window_in_days
}

resource "aws_secretsmanager_secret_version" "value" {
  count = var.value == null ? 0 : 1

  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(var.value)
  kms_key_id    = var.kms_key_id
}
