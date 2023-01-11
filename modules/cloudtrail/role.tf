resource "aws_iam_role" "cloudtrail_roles" {
  count              = var.enable_cloudwatch_logs ? 1 : 0
  name               = "CloudTrailToCloudWatchRole"
  assume_role_policy = var.cloudtrail_assume_role_policy_document
}

resource "aws_iam_policy" "cloudtrail_policy" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  name        = "send-cloudtrail-to-cloudwatch"
  description = "Policy for trail to send events to cloudwatch log groups."
  policy      = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.logs[0].arn}:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
              "${aws_cloudwatch_log_group.logs[0].arn}:*"
            ]
        }
      ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "cloudtrail_roles_policies" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  role       = aws_iam_role.cloudtrail_roles[0].name
  policy_arn = aws_iam_policy.cloudtrail_policy[0].arn
}
