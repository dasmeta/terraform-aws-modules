module "alb-to-cloudwatch" {
  count = var.enable_send_alb_logs_to_cloudwatch ? 1 : 0

  # source  = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch"
  # version = "2.9.2"
  source = "../alb-logs-to-s3-to-cloudwatch/"

  alb_log_bucket_name = local.alb_log_bucket_name
  region              = data.aws_region.current.name
  log_retention_days  = var.log_retention_days
}

module "alb-to-s3" {
  count = var.enable_send_alb_logs_to_s3 ? 1 : 0

  # source  = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch"
  # version = "2.9.2"
  source = "../alb-logs-to-s3-to-cloudwatch/"

  alb_log_bucket_name = local.alb_log_bucket_name
  region              = data.aws_region.current.name
  create_lambda       = false
  log_retention_days  = var.log_retention_days
}
