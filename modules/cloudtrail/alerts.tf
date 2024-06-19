module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.18.0"

  sns_topic = var.alerts.sns_topic_name
  alerts = [
    for name in var.alerts.events : {
      name : "${local.metrics_patterns_mapping[name]["name"]} alarm"
      source : "${local.metrics_namespace}/${local.metrics_patterns_mapping[name]["name"]}"
      statistic : "sum"
      filters : {}
      equation : "gte"
      fill_insufficient_data : true
      threshold : 1
      period : 10
    }
  ]
}
