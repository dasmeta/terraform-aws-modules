resource "aws_cloudwatch_log_group" "logs" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  name              = var.cloud_watch_logs_group_name
  retention_in_days = var.cloud_watch_logs_group_retention
}
