module "alb-logs-lambda" {
  source                = "../../"
  alb_log_bucket_name   = "alb-access-log-test-123232234232313"
  account_id            = "56**8"
  create_alb_log_bucket = false
}
