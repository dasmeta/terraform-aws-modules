module "alb-logs-lambda" {
  source                = "../../"
  alb_log_bucket_name   = "aws-cloudtrail-logs-565580475168-fb3dbb26"
  account_id            = "565580475168"
  create_alb_log_bucket = false
}
