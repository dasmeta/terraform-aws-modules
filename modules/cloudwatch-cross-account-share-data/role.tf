locals {
  #   policy_arns = [
  #     data.aws_iam_policy.CloudWatchReadOnlyAccess.arn,
  #     data.aws_iam_policy.CloudWatchAutomaticDashboardsAccess.arn,
  #     data.aws_iam_policy.AWSXrayReadOnlyAccess
  #   ]
  names = [
    "CloudWatchReadOnlyAccess",
    "CloudWatchAutomaticDashboardsAccess",
    "AWSXrayReadOnlyAccess"
  ]
}

data "aws_iam_policy" "policy" {
  for_each = toset(local.names)
  name     = each.value
}

data "aws_region" "current" {}

locals {
  policy = {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : var.aws_account_ids
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  }
}

resource "aws_iam_role" "aws-cloudwatch-metrics-role" {
  name = "CloudWatch-CrossAccountSharingRole"

  assume_role_policy = jsonencode(local.policy)
}

resource "aws_iam_role_policy_attachment" "policy" {
  for_each = toset(local.names)
  #   policy_arn = each.value

  policy_arn = data.aws_iam_policy.policy[each.key].arn
  role       = aws_iam_role.aws-cloudwatch-metrics-role.name
}
