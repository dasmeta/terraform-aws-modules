### SNS slack lambda notification about health checks ###

data "aws_sns_topic" "aws_sns_topic_slack_health_check" {
  count = local.notify_slack ? 1 : 0
  name  = "${replace("${var.domain_name}${var.resource_path}", "/[./]+/", "-")}-slack"
  depends_on = [
    module.notify_slack
  ]

}

### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  alarm_name          = "${var.alarm_prefix_down}${var.domain_name}${var.resource_path}"
  namespace           = var.namespace
  metric_name         = var.metric_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  unit                = var.unit
  dimensions = {
    HealthCheckId = aws_route53_health_check.healthcheck.id
  }
  alarm_description         = var.alarm_description_down
  alarm_actions             = local.alarm_actions
  insufficient_data_actions = []
  treat_missing_data        = var.treat_missing_data #"breaching"
  depends_on = [
    aws_route53_health_check.healthcheck
  ]
}
resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  alarm_name          = "${var.alarm_prefix_up}${var.domain_name}${var.resource_path}"
  namespace           = var.namespace
  metric_name         = var.metric_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  unit                = var.unit
  dimensions = {
    HealthCheckId = aws_route53_health_check.healthcheck.id
  }
  alarm_description         = var.alarm_description_up
  ok_actions                = local.alarm_actions
  insufficient_data_actions = []
  treat_missing_data        = var.treat_missing_data #"breaching"
  depends_on = [
    aws_route53_health_check.healthcheck
  ]
}
