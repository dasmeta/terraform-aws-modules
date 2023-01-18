module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.3.8"

  sns_topic = var.alerts.sns_topic_name
  alerts = [
    for name in var.alerts.events : {
      name : "${local.metrics_patterns_mapping[name]["name"]} alarm"
      source : "${local.metrics_namespace}/${local.metrics_patterns_mapping[name]["name"]}"
      statistic : "sum"
      filters : {}
      equation : "gte"
      threshold : 1
      period : 10
    }
  ]
}
