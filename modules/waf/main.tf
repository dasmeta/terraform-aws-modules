locals {
  rules = concat(
    length(var.whitelist_ips) != 0 && var.enable_whitelist
    ? [{
      name     = "whitelist-ips"
      priority = "1"
      action   = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }

      ip_set_reference_statement = {
        arn = aws_wafv2_ip_set.whitelist_ip_set[0].arn
      }
    }]
    : [],
    var.enable_default_rule ? local.default_rules : [],
    var.rules
  )
}

module "waf" {
  source  = "dasmeta/waf-webaclv2/aws"
  version = "0.0.1"

  name_prefix  = var.name
  alb_arn      = var.alb_arn
  alb_arn_list = var.alb_arn_list
  scope        = var.scope

  create_alb_association = var.create_alb_association
  allow_default_action   = var.allow_default_action # set to allow if not specified
  visibility_config      = var.visibility_config
  rules                  = local.rules

  tags = var.tags
}

resource "aws_wafv2_ip_set" "whitelist_ip_set" {
  name = "${var.name}-ip-whitelist"

  count = length(var.whitelist_ips) == 0 ? 0 : 1

  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.whitelist_ips
}
