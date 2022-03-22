output "iam_account_password_policy_expire_passwords" {
  value       = aws_iam_account_password_policy.default.expire_passwords
  description = "Indicates whether passwords in the account expire."
}
