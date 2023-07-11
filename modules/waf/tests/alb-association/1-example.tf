module "waf_alb" {
  source = "../../"
  name   = "waf_production"

  create_alb_association = true

  alb_arn_list = ["arn:aws:elasticloadbalancing:region:account-id:loadbalancer/app/alb-name/..."]
  visibility_config = {
    metric_name = "waf_production"
  }
}
