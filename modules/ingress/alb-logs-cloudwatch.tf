module "alb-to-cloudwatch" {
  count = var.enable_send_alb_logs_to_cloudwatch ? 1 : 0

  source = "../alb-logs-to-s3-to-cloudwatch"

  alb_log_bucket_name           = local.alb_log_bucket_name
  region                        = data.aws_region.current.name
  log_retention_days            = var.log_retention_days
  cloudwatch_log_retention_days = var.cloudwatch_log_retention_days
}

module "alb-to-s3" {
  count = var.enable_send_alb_logs_to_cloudwatch ? 0 : var.enable_send_alb_logs_to_s3 ? 1 : 0

  source = "../alb-logs-to-s3-to-cloudwatch"

  alb_log_bucket_name = local.alb_log_bucket_name
  region              = data.aws_region.current.name
  create_lambda       = false
  log_retention_days  = var.log_retention_days
}
