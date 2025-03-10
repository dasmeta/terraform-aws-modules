module "cw_alerts" {
  count = var.alarms.enabled ? 1 : 0

  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.18.0"

  sns_topic = var.alarms.sns_topic

  alerts = [
    {
      name   = "ALB ${var.name} has too many 5xx error"
      source = "AWS/ApplicationELB/HTTPCode_Target_5XX_Count"
      filters = {
        LoadBalancer = data.aws_lb.ingress.arn_suffix
      }
      period                 = try(var.alarms.custom_values.error_5xx.period, "60")
      statistic              = try(var.alarms.custom_values.error_5xx.statistic, "sum")
      threshold              = try(var.alarms.custom_values.error_5xx.threshold, "10")
      fill_insufficient_data = try(var.alarms.custom_values.error_5xx.fill_insufficient_data, true)
    },
    {
      name   = "ALB ${var.name} response time greater than 10sec."
      source = "AWS/ApplicationELB/TargetResponseTime"
      filters = {
        LoadBalancer = data.aws_lb.ingress.arn_suffix
      }
      period                 = try(var.alarms.custom_values.response_time.period, "60")
      statistic              = try(var.alarms.custom_values.response_time.statistic, "avg")
      threshold              = try(var.alarms.custom_values.response_time.threshold, "10")
      fill_insufficient_data = try(var.alarms.custom_values.response_time.fill_insufficient_data, true)
    },
    {
      name   = "ALB ${var.name} request count increased"
      source = "AWS/ApplicationELB/RequestCount"
      filters = {
        LoadBalancer = data.aws_lb.ingress.arn_suffix
      }
      period                 = try(var.alarms.custom_values.response_time.period, "60")
      statistic              = try(var.alarms.custom_values.response_time.statistic, "avg")
      threshold              = try(var.alarms.custom_values.response_time.threshold, "50")
      fill_insufficient_data = try(var.alarms.custom_values.response_time.fill_insufficient_data, true)
    },
  ]

  depends_on = [
    kubernetes_ingress_v1.this_v1,
    data.aws_lb.ingress
  ]
}
