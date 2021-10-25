data "aws_caller_identity" "current" {
  provider = aws.virginia
}

resource "aws_sns_topic" "this" {
  provider = aws.virginia

  display_name = "${replace("${var.domen_name}${var.resource_path}", "/[./]+/", "-")}-slack"
  name         = "${replace("${var.domen_name}${var.resource_path}", "/[./]+/", "-")}-slack"
  policy       = jsonencode(
  {
    Id        = "__default_policy_ID"
    Statement = [
      {
        Action    = [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish",
          "SNS:Receive",
        ]
        Condition = {
          StringEquals = {
            "AWS:SourceOwner" = "${data.aws_caller_identity.current.account_id}"
          }
        }
        Effect    = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource  = "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:${replace("${var.domen_name}${var.resource_path}", "/[./]+/", "-")}-slack"
        Sid       = "__default_statement_ID"
      },
    ]
    Version   = "2008-10-17"
  }
  )
  tags         = {}
}

### SNS slack lambda notification about health checks ###

data "aws_sns_topic" "aws_sns_topic_slack_health_check" {
  
  name = "${replace("${var.domen_name}${var.resource_path}", "/[./]+/", "-")}-slack" 
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.this,
  ]
  provider                  = aws.virginia
}

data "aws_lambda_function" "health_check_slack_notification_lambda" {
  function_name = "${replace("${var.domen_name}${var.resource_path}", "/[./]+/", "-")}-slack"
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.this,
  ]
  provider                  = aws.virginia
}

resource "aws_sns_topic_subscription" "lambda" {
  provider                  = aws.virginia

  topic_arn = data.aws_sns_topic.aws_sns_topic_slack_health_check.arn
  protocol  = "lambda"
  endpoint  = data.aws_lambda_function.health_check_slack_notification_lambda.arn
  
}
