### SNS slack lambda notification about health checks ###

data "aws_sns_topic" "aws_sns_topic_slack_health_check" {
  
  name = "${replace(var.pod_name, ".", "-")}-slack" 
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.route53-healthcheck,
  ]
}

data "aws_lambda_function" "health_check_slack_notification_lambda" {
  function_name = "${replace(var.pod_name, ".", "-")}-to-slack"
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.route53-healthcheck,
  ]
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = data.aws_sns_topic.aws_sns_topic_slack_health_check.arn
  protocol  = "lambda"
  endpoint  = data.aws_lambda_function.health_check_slack_notification_lambda.arn
  
}
