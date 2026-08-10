data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Per-store IAM role, assumed by the external-secrets controller (role chaining). Trust is
# limited to the controller's base role — no IAM users, no static access keys.
resource "aws_iam_role" "store" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = var.controller_role_arn }
        Action    = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

# Least-privilege read access scoped to secrets whose name starts with the store name.
resource "aws_iam_policy" "store" {
  name        = "${local.role_name}-policy"
  description = "Read access for external-secrets store ${var.name} (secrets ${var.name}*)."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
        ]
        Resource = [
          "arn:aws:secretsmanager:${local.region}:${data.aws_caller_identity.current.account_id}:secret:${var.name}*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "store" {
  role       = aws_iam_role.store.name
  policy_arn = aws_iam_policy.store.arn
}
