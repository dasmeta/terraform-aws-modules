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
