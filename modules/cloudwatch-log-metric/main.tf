resource "aws_cloudwatch_log_metric_filter" "metric_filter" {  
  name           = var.name
  pattern        = var.filter_pattern
  log_group_name = var.log_group_name

  metric_transformation {
    name      = var.metric_transformation_name
    namespace = var.metric_transformation_namespace
    value     = var.metric_transformation_value
    unit      = var.metric_transformation_unit
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  count = var.create_log_group ? 1 : 0
  name  = var.log_group_name
}
