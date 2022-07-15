resource "aws_cloudwatch_log_group" "access_logs" {
  count = var.enable_access_logs ? 1 : 0

  name = "api-gateway-${var.name}-${var.stage_name}-logs"
}
