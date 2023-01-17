module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.3.8"

  count = var.log_metrics.alerts.enabled ? 1 : 0

  sns_topic = var.sns_topic_name
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
