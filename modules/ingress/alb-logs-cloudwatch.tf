module "alb-to-cloudwatch" {
  count = var.enable_send_alb_logs_to_cloudwatch ? 1 : 0

  source  = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch"
  version = "2.9.2"

  alb_log_bucket_name = local.alb_log_bucket_name
  region              = data.aws_region.current.name
}
