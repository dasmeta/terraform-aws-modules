module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.3.8"

  count = var.log_metrics.enabled ? 1 : 0

  sns_topic = var.alarm_actions.enabled ? var.alarm_actions.topic_name : var.log_metrics.sns_topic
  alerts = [
    for name in var.log_metrics.enabled_metrics : {
      name : "${local.metrics_patterns_mapping[name]["name"]} alarm"
      source : "${var.log_metrics.metrics_namespace}/${local.metrics_patterns_mapping[name]["name"]}"
      statistic : "sum"
      filters : {}
      equation : "gte"
      threshold : 1
      period : 10
    }
  ]
}
