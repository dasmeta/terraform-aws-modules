module "waf" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "3.5.0"

  name_prefix  = var.name
  alb_arn      = var.alb_arn
  alb_arn_list = var.alb_arn_list
  scope        = var.scope

  create_alb_association = var.create_alb_association

  allow_default_action = var.allow_default_action # set to allow if not specified

  visibility_config = var.visibility_config

  rules = var.rules

  tags = var.tags
}


# resource "aws_wafv2_web_acl" "example" {
#   name        = var.name
#   description = "WAF ${var.name}"
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   dynamic "rule" {
#     for_each = var.rules
#     content {
#       name     = rule.value["name"]
#       priority = rule.value["priority"]
#       #   override_action   = rule.value["override_action"]
#       statement = rule.value["statement"]
#       #   visibility_config = rule.value["visibility_config"]
#     }
#   }

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }
# }

# resource "aws_wafv2_web_acl_association" "example" {
#   resource_arn = var.resource_arn
#   web_acl_arn  = var.web_acl_arn
# }
