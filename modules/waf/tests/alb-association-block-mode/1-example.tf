module "waf_alb" {
  source = "../../"
  name   = "waf_test"

  create_alb_association = true

  alb_arn_list = [aws_lb.test.arn]
  visibility_config = {
    metric_name = "waf_test"
  }

  alarms = {
    enabled   = false
    sns_topic = ""
  }
}
