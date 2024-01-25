module "waf_alb" {
  source = "../../"
  name   = "waf_test_count"

  mode                   = "count"
  create_alb_association = true

  alb_arn_list = ["arn:aws:elasticloadbalancing:eu-central-1:1234567890:loadbalancer/app/test/asadadadadada"]
  visibility_config = {
    metric_name = "waf_test_count"
  }
}
