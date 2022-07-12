resource "aws_iam_role" "logger" {
  name = "${var.name}-cron-success-logger"

  assume_role_policy = <<EOL
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Principal": {
              "Service": "sns.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
EOL

  inline_policy {
    name    = "${var.name}-cron-success-logger"
    policy = <<EOL
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOL
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "${var.name}-cron-sns-policy-id"

  statement {
    sid    = "${var.name}-cron-sns-statement-id"
    effect = "Allow"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = ["${aws_sns_topic.this.arn}"]
  }

  statement {
    sid     = "${var.name}-cron-sns-permission-upper-policy"
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.this.arn}"]
  }

  statement {
    sid     = "${var.name}-cron-sns-permission-policy"
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["${aws_sns_topic.this.arn}"]
  }
}

resource "aws_sns_topic_policy" "cw_event_permissions" {
  arn = aws_sns_topic.this.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
