data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_policy" "policy" {
  name        = "external-secrets-access-policy-for-store-${local.sanitized-name}"
  path        = "/"
  description = "Policy gives external secrets store access to ${var.name}* secrets"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.name}*",
        ]
      }
    ]
  })
}
