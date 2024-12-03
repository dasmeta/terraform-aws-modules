module "kms_for_cloudwatch" {
  source = "../../"

  kms_key_description = "Encryption key for example log group"
  kms_alias_name      = "example-log-group-key"
  kms_key_cloudwatch  = false
  kms_key_policy = jsonencode(
    {
      Id = "CloudWatch"
      Statement = [
        {
          Action = [
            "kms:*"
          ],
          Effect = "Allow"
          Principal = {
            Service = "logs.amazonaws.com"
          }

          Resource = "*"
          Sid      = "AllowCloudWatchToUseKey"
        }
      ]
      Version = "2012-10-17"
    }
  )
}
