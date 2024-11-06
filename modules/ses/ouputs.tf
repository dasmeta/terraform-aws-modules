output "dkim_records" {
  description = "DNS records for DKIM"
  value       = [local.dkim_record_0, local.dkim_record_1, local.dkim_record_2]
}

output "smtp_credentials" {
  value = { for k, v in aws_iam_access_key.ses_user : k =>
    {
      user     = v.user,
      password = v.ses_smtp_password_v4
    }
  }
  description = "SMTP Username and Passwort"
  sensitive   = true
}

output "secret_keys" {
  value = { for v in aws_iam_access_key.ses_user : v.user =>
    {
      user   = v.user,
      id     = v.id
      secret = v.secret
    }
  }
  description = "IAM Access Key ID and Secret"
  sensitive   = true
}
