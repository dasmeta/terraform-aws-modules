locals {
  secrets = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.current.secret_string))
}

data "aws_secretsmanager_secret" "by_secret_name" {
  name = var.name
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.by_secret_name.id
}
