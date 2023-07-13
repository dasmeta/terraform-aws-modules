module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.6.0"

  count = var.create_alerts ? 1 : 0

  sns_topic = var.sns_topic_name
  alerts = [
    {
      name   = "WAF Blocked request count"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "ALL",
      }
      period    = 86400
      statistic = "sum"
      threshold = 2
    },
  ]
  enable_insufficient_data_actions = false
  enable_ok_actions                = false
}
