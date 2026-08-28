module "this" {
  source  = "terraform-aws-modules/global-accelerator/aws"
  version = "~> 3.0"

  name            = var.name
  enabled         = var.enabled
  ip_address_type = var.ip_address_type
  listeners       = local.listeners

  flow_logs_enabled   = var.flow_logs.enabled
  flow_logs_s3_bucket = var.flow_logs.s3_bucket
  flow_logs_s3_prefix = var.flow_logs.s3_prefix

  tags = var.tags
}
