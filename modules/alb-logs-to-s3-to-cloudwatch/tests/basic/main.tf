module "alb-to-cloudwatch" {
  source              = "../../"
  alb_log_bucket_name = "alb-logs-stage-2"
  region              = "eu-central-1"
}
