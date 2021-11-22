### SNS slack lambda notification about health checks ###

data "aws_sns_topic" "aws_sns_topic_slack_health_check" {
  
  name = "${replace("${var.domain_name}${var.resource_path}", "/[./]+/", "-")}-slack" 
  depends_on = [
    module.notify_slack
  ]
  
}

### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  alarm_name                = ":x: ${var.domain_name}${var.resource_path}"
  namespace                 = var.namespace
  metric_name               = var.metric_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  unit                      = var.unit
  dimensions                = {
    HealthCheckId = aws_route53_health_check.healthcheck.id
  }
  alarm_description         = var.alarm_description_down
  alarm_actions             = [
    aws_sns_topic.this-email.arn, // email
    aws_sns_topic.this-sms.arn, // sms
    data.aws_sns_topic.aws_sns_topic_slack_health_check.arn // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.insufficient_data_actions #"breaching"
  depends_on                = [
    aws_route53_health_check.healthcheck
  ]
}
resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  alarm_name                = ":white_check_mark: ${var.domain_name}${var.resource_path}"
  namespace                 = var.namespace
  metric_name               = var.metric_name
  comparison_operator       = var.comparison_operator
  evaluation_periods        = var.evaluation_periods
  period                    = var.period
  statistic                 = var.statistic
  threshold                 = var.threshold
  unit                      = var.unit
  dimensions                = {
    HealthCheckId = aws_route53_health_check.healthcheck.id
  }
  alarm_description         = var.alarm_description_up
  ok_actions                = [
    aws_sns_topic.this-email.arn, // email
    aws_sns_topic.this-sms.arn, // sms
    data.aws_sns_topic.aws_sns_topic_slack_health_check.arn // slack
  ]
  insufficient_data_actions = []
  treat_missing_data        = var.insufficient_data_actions #"breaching"
  depends_on                = [
    aws_route53_health_check.healthcheck
  ]
}
