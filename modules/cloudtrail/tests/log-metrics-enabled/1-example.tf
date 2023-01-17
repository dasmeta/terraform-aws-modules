module "this" {
  source = "../../"

  name = "audit-project"

  enable_cloudwatch_logs      = true
  cloud_watch_logs_group_name = "audit-project-cloudtrail-logs"

  log_metrics = {
    enabled         = true
    enabled_metrics = ["iam-user", "elb"]
  }
}
