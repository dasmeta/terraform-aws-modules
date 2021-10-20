module "slack_notification_lambda_health_checks" {
  providers = {
    aws = aws
    aws.virginia = aws.virginia
  }

  source = "./lambda/notification/health_check"
  slack_hook_url = var.slack_hook_url
  domen_name = var.domen_name
}
