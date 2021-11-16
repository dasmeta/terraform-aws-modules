module "slack_notification_lambda_health_checks" {


  source = "./lambda"
  slack_hook_url = var.slack_hook_url
  domen_name = var.domen_name
  resource_path = var.resource_path
}
