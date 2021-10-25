### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  provider                  = aws.virginia

  alarm_name                = ":x: ${var.pod_name}"
  namespace                 = var.namespace
  metric_name               = var.metric_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  unit                      = var.unit
  dimensions                = var.dimensions
  alarm_description         = var.alarm_description_down
  alarm_actions             = [
    aws_sns_topic.route53-healthcheck.arn, // email
    aws_sns_topic.route53-healthcheck-sms.arn, // sms
    data.aws_sns_topic.aws_sns_topic_slack_health_check.arn // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.insufficient_data_actions #"breaching"
  # depends_on                = [
  #   aws_route53_health_check.healthcheck
  # ]
  tags = {
    Name = "${var.pod_name}-alerts-from-to-slack"
  }
}
resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  provider                  = aws.virginia

  alarm_name                = ":white_check_mark: ${var.pod_name}"
  namespace                 = var.namespace
  metric_name               = var.metric_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  unit                      = var.unit
  dimensions                = var.dimensions
  alarm_description         = var.alarm_description_up
  ok_actions                = [
    aws_sns_topic.route53-healthcheck.arn, // email
    aws_sns_topic.route53-healthcheck-sms.arn, // sms
    data.aws_sns_topic.aws_sns_topic_slack_health_check.arn // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.insufficient_data_actions #"breaching"
  # depends_on                = [
  #   aws_route53_health_check.healthcheck
  # ]
  tags = {
    Name = "${var.pod_name}-alerts-from-to-slack"
  }
}
