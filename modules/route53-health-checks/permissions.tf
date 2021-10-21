
### Topic permission
data "aws_sns_topic" "route53-healthcheck" {
  provider = aws.virginia

  name = "${replace(var.domen_name, "/[./]+/", "-")}-slack"
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.route53-healthcheck,
  ]
}

# Allow sns to execute created lambda function
resource "aws_lambda_permission" "sns_health_check_slack_notification_permission" {
  provider = "aws.virginia"

  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${replace(var.domen_name, "/[./]+/", "-")}-slack"
  principal     = "sns.amazonaws.com"
  source_arn = data.aws_sns_topic.route53-healthcheck.arn
  depends_on = [
    module.slack_notification_lambda_health_checks,aws_sns_topic.route53-healthcheck,
  ]
}
