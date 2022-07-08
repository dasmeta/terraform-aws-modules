data "aws_iam_policy" "this" {
  name = "CloudWatchAgentServerPolicy"
}
data "aws_region" "current" {}

resource "aws_iam_role" "aws-cloudwatch-metrics-role" {
  name = "${var.cluster_name}-cloudwatch-metrics-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_provider_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${data.aws_region.current.name}.amazonaws.com/id/${var.eks_oidc_root_ca_thumbprint}:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = data.aws_iam_policy.this.arn
  role       = aws_iam_role.aws-cloudwatch-metrics-role.name
}
