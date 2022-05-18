resource "aws_iam_group_policy" "my_developer_policy" {
  name  = var.name
  group = aws_iam_group.read_only.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "aws-portal:ViewBilling",
          "aws-portal:ViewUsage",
          "autoscaling:Describe*",
          "cloudformation:DescribeStacks",
          "cloudformation:DescribeStackEvents",
          "cloudformation:DescribeStackResources",
          "cloudformation:GetTemplate",
          "cloudfront:Get*",
          "cloudfront:List*",
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables",
          "ec2:Describe*",
          "elasticache:Describe*",
          "elasticbeanstalk:Check*",
          "elasticbeanstalk:Describe*",
          "elasticbeanstalk:List*",
          "elasticbeanstalk:RequestEnvironmentInfo",
          "elasticbeanstalk:RetrieveEnvironmentInfo",
          "elasticloadbalancing:Describe*",
          "iam:List*",
          "iam:Get*",
          "route53:Get*",
          "route53:List*",
          "rds:Describe*",
          "s3:Get*",
          "s3:List*",
          "sdb:GetAttributes",
          "sdb:List*",
          "sdb:Select*",
          "ses:Get*",
          "ses:List*",
          "sns:Get*",
          "sns:List*",
          "sqs:GetQueueAttributes",
          "sqs:ListQueues",
          "sqs:ReceiveMessage",
          "storagegateway:List*",
          "storagegateway:Describe*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group" "read_only" {
  name = var.name
}

resource "aws_iam_group_membership" "team" {
  count = var.attach_users_to_group ? 1 : 0

  name  = var.name
  users = var.users
  group = aws_iam_group.read_only.name
}
