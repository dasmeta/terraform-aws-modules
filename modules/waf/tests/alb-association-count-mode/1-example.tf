module "waf_alb" {
  source = "../../"
  name   = "waf_test_count"

  mode                   = "count"
  create_alb_association = true

  alb_arn_list = [aws_lb.test.arn]
  visibility_config = {
    metric_name = "waf_test_count"
  }

  alarms = {
    enabled   = false
    sns_topic = ""
  }
}
