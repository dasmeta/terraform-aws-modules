module "this" {
  source = "../../"

  name = "audit-project"

  enable_cloudwatch_logs      = true
  cloud_watch_logs_group_name = "audit-project-cloudtrail-logs"

  alerts = {
    events = ["iam-user-creation-or-deletion"]
  }
}
