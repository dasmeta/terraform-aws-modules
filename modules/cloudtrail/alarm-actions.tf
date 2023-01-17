module "cloudwatch_alarm_actions" {
  source  = "dasmeta/monitoring/aws//modules/cloudwatch-alarm-actions"
  version = "1.3.8"

  count = var.alarm_actions.enabled ? 1 : 0

  topic_name          = var.alarm_actions.topic_name
  email_addresses     = var.alarm_actions.email_addresses
  phone_numbers       = var.alarm_actions.phone_numbers
  web_endpoints       = var.alarm_actions.web_endpoints
  slack_webhooks      = var.alarm_actions.slack_webhooks
  servicenow_webhooks = var.alarm_actions.servicenow_webhooks
}
