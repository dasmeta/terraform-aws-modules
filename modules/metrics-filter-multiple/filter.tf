# module "cloudwatch_metric_filter" {
#   # source  = "dasmeta/modules/aws//modules/metrics-server"
#   source = "../../../../dasmeta/terraform-aws-modules/modules/metric-filter"

#   # log_group_name = local.log_groups[local.monitoring.log_based_metrics[0].source]
#   log_group_name = "log group from map"

#   metrics_patterns = [
#     {
#       name    = "name from map"
#       pattern = "pattern from map"
#       unit    = "None" # ???
#     }
#   ]

#   metrics_namespace = "LogBasedMetrics/UCFirst(GroupKeyFrommap)"

#   providers = {
#     aws = aws.logging
#   }
# }


module "cloudwatch_metric_filter" {
  for_each = { for pattern in var.patterns : pattern.name => pattern }
  source   = "../metric-filter"

  metrics_patterns = [
    {
      name       = each.value.name
      pattern    = each.value.pattern
      unit       = "None"
      dimensions = each.value.dimensions
    }
  ]

  log_group_name    = lookup(var.log_groups, each.value.source, "")
  metrics_namespace = var.metrics_namespace
}
