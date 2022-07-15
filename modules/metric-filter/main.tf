resource "aws_cloudwatch_log_metric_filter" "yada" {
  for_each = { for mp in var.metrics_patterns : mp.name => mp }

  name           = each.value.name
  pattern        = each.value.pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name       = each.value.name
    namespace  = var.metrics_namespace
    value      = "1"
    unit       = each.value.unit
    dimensions = var.dimensions
  }
}

