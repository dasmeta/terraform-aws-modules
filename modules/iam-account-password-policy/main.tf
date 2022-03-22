resource "aws_iam_account_password_policy" "this" {
  allow_users_to_change_password = var.allow_users_to_change_password
  minimum_password_length        = var.minimum_password_length
  require_lowercase_characters   = var.require_lowercase_characters
  require_numbers                = var.require_numbers
  require_symbols                = var.require_symbols
  require_uppercase_characters   = var.require_uppercase_characters
  max_password_age               = var.max_password_age
  hard_expiry                    = var.hard_expiry
  password_reuse_prevention      = var.password_reuse_prevention
}
