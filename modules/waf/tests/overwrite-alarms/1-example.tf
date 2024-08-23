module "waf_alb" {
  #   source  = "dasmeta/modules/aws//modules/waf/"
  #   version = "2.5.1"
  source = "../../"
  name   = "test"

  create_alb_association = true

  alb_arn_list = [
    aws_lb.test1.arn,
    aws_lb.test2.arn
  ]

  visibility_config = {
    metric_name = "test"
  }

  alarms = {
    enabled   = true
    sns_topic = "test"
    custom_values = {
      all = {
        statistic = "avg"
        threshold = "90"
        period    = "300"
      }
      knownbadinputsruleset = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
      linuxrulesset = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
      ipreputationlist = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
      commonruleset = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
      sqliruleset = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
      unixruleset = {
        period    = 60
        statistic = "count"
        threshold = 100
      }
    }
  }

}
