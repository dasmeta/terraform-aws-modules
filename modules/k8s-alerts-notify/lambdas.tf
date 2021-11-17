module "slack_notification_lambda_health_checks" {
  source         = "./lambda/notification/health_check"
  slack_hook_url = var.slack_hook_url
  pod_name       = var.pod_name
}
