locals {
  alert_variables_object = lookup(var.alert_variables, var.alert_type_name, "default")
  default_alert_variables_object = lookup(var.default_alerts_variables,var.alert_type_name,"default")
}
output "testobject" {
  value = local.alert_variables_object
}

### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  alarm_name          = ":x: ${var.alarm_name}"
  namespace           = lookup(local.alert_variables_object,"namespace",lookup(local.default_alert_variables_object,"namespace","ContainerInsights"))
  metric_name         = lookup(local.alert_variables_object,"metric_name",lookup(local.default_alert_variables_object,"metric_name","pod_number_of_container_restarts"))
  comparison_operator = lookup(local.alert_variables_object,"comparison_operator",lookup(local.default_alert_variables_object,"comparison_operator","GreaterThanOrEqualToThreshold"))
  evaluation_periods  = lookup(local.alert_variables_object,"evaluation_periods",lookup(local.default_alert_variables_object,"evaluation_periods","1"))
  period              = lookup(local.alert_variables_object,"period",lookup(local.default_alert_variables_object,"period","60"))
  statistic           = lookup(local.alert_variables_object,"statistic",lookup(local.default_alert_variables_object,"statistic","Average"))
  threshold           = lookup(local.alert_variables_object,"threshold",lookup(local.default_alert_variables_object,"threshold","1"))
  unit                = lookup(local.alert_variables_object,"unit",lookup(local.default_alert_variables_object,"unit","Count"))
  dimensions          = lookup(local.alert_variables_object,"dimensions",lookup(local.default_alert_variables_object,"dimensions",{}))
  treat_missing_data        = lookup(local.alert_variables_object,"treat_missing_data",lookup(local.default_alert_variables_object,"treat_missing_data","breaching")) #"breaching"
  insufficient_data_actions = lookup(local.alert_variables_object,"insufficient_data_actions",lookup(local.default_alert_variables_object,"insufficient_data_actions",[]))
  alarm_description         = lookup(local.alert_variables_object,"alarm_description_down",lookup(local.default_alert_variables_object,"alarm_description_down","This metric monitors pod restarts."))
  alarm_actions             = [
    aws_sns_topic.k8s-alerts-notify-email.arn, // email
    aws_sns_topic.k8s-alerts-notify-sms.arn,   // sms
    module.notify_slack.this_slack_topic_arn   // slack
  ]
  
  tags = {
    Name = "${var.alarm_name}-alerts"
  }
}


resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  alarm_name          = ":white_check_mark: ${var.alarm_name}"
  namespace           = lookup(local.alert_variables_object,"namespace",lookup(local.default_alert_variables_object,"namespace","ContainerInsights"))
  metric_name         = lookup(local.alert_variables_object,"metric_name",lookup(local.default_alert_variables_object,"metric_name","pod_number_of_container_restarts"))
  comparison_operator = lookup(local.alert_variables_object,"comparison_operator",lookup(local.default_alert_variables_object,"comparison_operator","GreaterThanOrEqualToThreshold"))
  evaluation_periods  = lookup(local.alert_variables_object,"evaluation_periods",lookup(local.default_alert_variables_object,"evaluation_periods","1"))
  period              = lookup(local.alert_variables_object,"period",lookup(local.default_alert_variables_object,"period","60"))
  statistic           = lookup(local.alert_variables_object,"statistic",lookup(local.default_alert_variables_object,"statistic","Average"))
  threshold           = lookup(local.alert_variables_object,"threshold",lookup(local.default_alert_variables_object,"threshold","1"))
  unit                = lookup(local.alert_variables_object,"unit",lookup(local.default_alert_variables_object,"unit","Count"))
  dimensions          = lookup(local.alert_variables_object,"dimensions",lookup(local.default_alert_variables_object,"dimensions",{}))
  treat_missing_data        = lookup(local.alert_variables_object,"treat_missing_data",lookup(local.default_alert_variables_object,"treat_missing_data","breaching")) #"breaching"
  insufficient_data_actions = lookup(local.alert_variables_object,"insufficient_data_actions",lookup(local.default_alert_variables_object,"insufficient_data_actions",[]))
  alarm_description         = lookup(local.alert_variables_object,"alarm_description_up",lookup(local.default_alert_variables_object,"alarm_description_up","This metric monitors pod restarts."))
  ok_actions = [
    aws_sns_topic.k8s-alerts-notify-email.arn, // email
    aws_sns_topic.k8s-alerts-notify-sms.arn,   // sms
    module.notify_slack.this_slack_topic_arn   // slack
  ]

  tags = {
    Name = "${var.alarm_name}-alerts"
  }
}
