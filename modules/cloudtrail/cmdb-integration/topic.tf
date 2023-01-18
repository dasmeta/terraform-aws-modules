module "topic" {
  source  = "dasmeta/sns/aws//modules/topic"
  version = "1.0.0"

  name = var.name
  # email/sms/endpoint(https) subscriptions
  subscriptions = var.cmdb_integration_config.subscriptions
}
