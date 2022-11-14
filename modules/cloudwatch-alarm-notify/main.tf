locals {
  default = {
    k8s_alerts = {
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "1"
      period                    = "300"
      namespace                 = "ContainerInsights"
      unit                      = "Percent"
      metric_name               = "pod_cpu_utilization"
      statistic                 = "Average"
      threshold                 = "25"
      treat_missing_data        = "notBreaching"
      insufficient_data_actions = []
    },
    alb_alerts = {
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "1"
      period                    = "60"
      namespace                 = "AWS/ApplicationELB"
      unit                      = "Count"
      metric_name               = "HTTPCode_ELB_5XX_Count"
      statistic                 = "Sum"
      threshold                 = "20"
      treat_missing_data        = "notBreaching"
      insufficient_data_actions = []
    },
    rds_alerts = {
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "2"
      period                    = "300"
      namespace                 = "AWS/RDS"
      unit                      = null
      statistic                 = "Average"
      treat_missing_data        = "breaching"
      insufficient_data_actions = []
    },
    other = {
      comparison_operator       = "GreaterThanOrEqualToThreshold"
      evaluation_periods        = "1"
      period                    = "300"
      namespace                 = "ContainerInsights"
      unit                      = "Percent"
      metric_name               = "pod_cpu_utilization"
      statistic                 = "Average"
      threshold                 = "25"
      treat_missing_data        = "notBreaching"
      insufficient_data_actions = []
    }
  }
  alarm_description_up           = "This metric monitors ${var.alarm_name} when threshold < ${var.threshold != "" ? var.threshold : lookup(local.default_alert_variables_object, "threshold", "default_threshold")}"
  alarm_description_down         = "This metric monitors ${var.alarm_name} when threshold > ${var.threshold != "" ? var.threshold : lookup(local.default_alert_variables_object, "threshold", "default_threshold")}"
  default_alert_variables_object = lookup(local.default, var.alert_type_name, {})
  actions = concat(
    aws_sns_topic.k8s-alerts-notify-email.*.arn,         // email
    aws_sns_topic.k8s-alerts-notify-sms.*.arn,           // sms
    aws_sns_topic.k8s-alerts-notify-opsgenie.*.arn,      // Opsgenie
    module.notify_slack.*.this_slack_topic_arn,          // slack
    var.sns_topic_arn == null ? [] : [var.sns_topic_arn] // custom
  )
  # ensure that there is no % in the tag value. Sometimes you want the name of
  # the metric to be part of the alarm name. Some metrics have the % sign in the name.
  tag_name = replace("${var.alarm_name}-alerts", "%", "Percent")
}

### Create a cloudwatch healthcheck metric alarm
resource "aws_cloudwatch_metric_alarm" "metric-alarm-down" {
  alarm_name                = "${var.alarm_prefix_down}${var.alarm_name}"
  namespace                 = var.namespace != "" ? var.namespace : lookup(local.default_alert_variables_object, "namespace", "default_namespace")
  metric_name               = var.metric_name != "" ? var.metric_name : lookup(local.default_alert_variables_object, "metric_name", "default_metric_name")
  comparison_operator       = var.comparison_operator != "" ? var.comparison_operator : lookup(local.default_alert_variables_object, "comparison_operator", "default_comparison_operator")
  evaluation_periods        = var.evaluation_periods != "" ? var.evaluation_periods : lookup(local.default_alert_variables_object, "evaluation_periods", "default_evaluation_periods")
  period                    = var.period != "" ? var.period : lookup(local.default_alert_variables_object, "period", "default_period")
  statistic                 = var.statistic != "" ? var.statistic : lookup(local.default_alert_variables_object, "statistic", "default_statistic")
  threshold                 = var.threshold != "" ? var.threshold : lookup(local.default_alert_variables_object, "threshold", "default_threshold")
  unit                      = var.unit != "" ? var.unit : lookup(local.default_alert_variables_object, "unit", "default_unit")
  dimensions                = var.dimensions
  treat_missing_data        = var.treat_missing_data != "" ? var.treat_missing_data : lookup(local.default_alert_variables_object, "treat_missing_data", "default_treat_missing_data") #"breaching"
  insufficient_data_actions = var.insufficient_data_actions != [] ? var.insufficient_data_actions : lookup(local.default_alert_variables_object, "insufficient_data_actions", "default_insufficient_data_actions")
  alarm_description         = local.alarm_description_down
  alarm_actions             = local.actions

  tags = {
    Name = local.tag_name
  }
}


resource "aws_cloudwatch_metric_alarm" "metric-alarm-up" {
  alarm_name                = "${var.alarm_prefix_up}${var.alarm_name}"
  namespace                 = var.namespace != "" ? var.namespace : lookup(local.default_alert_variables_object, "namespace", "default_namespace")
  metric_name               = var.metric_name != "" ? var.metric_name : lookup(local.default_alert_variables_object, "metric_name", "default_metric_name")
  comparison_operator       = var.comparison_operator != "" ? var.comparison_operator : lookup(local.default_alert_variables_object, "comparison_operator", "default_comparison_operator")
  evaluation_periods        = var.evaluation_periods != "" ? var.evaluation_periods : lookup(local.default_alert_variables_object, "evaluation_periods", "default_evaluation_periods")
  period                    = var.period != "" ? var.period : lookup(local.default_alert_variables_object, "period", "default_period")
  statistic                 = var.statistic != "" ? var.statistic : lookup(local.default_alert_variables_object, "statistic", "default_statistic")
  threshold                 = var.threshold != "" ? var.threshold : lookup(local.default_alert_variables_object, "threshold", "default_threshold")
  unit                      = var.unit != "" ? var.unit : lookup(local.default_alert_variables_object, "unit", "default_unit")
  dimensions                = var.dimensions
  treat_missing_data        = var.treat_missing_data != "" ? var.treat_missing_data : lookup(local.default_alert_variables_object, "treat_missing_data", "default_treat_missing_data") #"breaching"
  insufficient_data_actions = var.insufficient_data_actions != [] ? var.insufficient_data_actions : lookup(local.default_alert_variables_object, "insufficient_data_actions", "default_insufficient_data_actions")
  alarm_description         = local.alarm_description_up
  ok_actions                = local.actions

  tags = {
    Name = local.tag_name
  }
}
