### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  alarm_name          = ":x: ${var.alarm_name}"
  namespace           = var.namespace
  metric_name         = var.metric_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  unit                = var.unit
  dimensions          = var.dimensions
  alarm_description   = var.alarm_description_down
  alarm_actions = [
    aws_sns_topic.k8s-alerts-notify-email.arn, // email
    aws_sns_topic.k8s-alerts-notify-sms.arn,   // sms
    module.notify_slack.this_slack_topic_arn   // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.treat_missing_data #"breaching"
  tags = {
    Name = "${var.alarm_name}-alerts"
  }
}
resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  alarm_name          = ":white_check_mark: ${var.alarm_name}"
  namespace           = var.namespace
  metric_name         = var.metric_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  unit                = var.unit
  dimensions          = var.dimensions
  alarm_description   = var.alarm_description_up
  ok_actions = [
    aws_sns_topic.k8s-alerts-notify-email.arn, // email
    aws_sns_topic.k8s-alerts-notify-sms.arn,   // sms
    module.notify_slack.this_slack_topic_arn   // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.treat_missing_data #"breaching"
  tags = {
    Name = "${var.alarm_name}-alerts"
  }
}
