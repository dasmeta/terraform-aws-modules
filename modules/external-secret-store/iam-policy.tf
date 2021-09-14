resource "aws_iam_policy" "policy" {
  name        = "external-secrets-access-policy-for-store-${var.name}"
  path        = "/"
  description = "Policy gives external secrets store access to ${var.name}-* secrets"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ],
        "Resource": [
          "arn:aws:secretsmanager:${var.region}:${var.aws_account_id}:secret:${var.name}-*",
        ]
      }
    ]
  })
}
