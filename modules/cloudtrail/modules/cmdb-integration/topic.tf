module "topic" {
  source  = "dasmeta/sns/aws//modules/topic"
  version = "1.2.8"

  name          = var.name
  subscriptions = var.configs.subscriptions
}
