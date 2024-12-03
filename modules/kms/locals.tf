locals {
  cloudwatch_logs_policy = jsonencode(
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
        },
        {
          Action = [
            "kms:*"
          ],
          Effect = "Allow"
          Principal = {
            AWS = data.aws_caller_identity.current.account_id
          }

          Resource = "*"
          Sid      = "AllowAccountManageKey"
        }
      ]
      Version = "2012-10-17"
    }
  )
}
