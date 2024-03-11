module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.6.0"

  count = var.create_alerts ? 1 : 0

  sns_topic = var.sns_topic_name
  alerts = [
    {
      name   = "WAF ALL Blocked request count"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "ALL",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 100
    },
    {
      name   = "WAF Blocked request with AWSManagedRulesKnownBadInputsRuleSet rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesKnownBadInputsRuleSet",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
    {
      name   = "WAF Blocked request with AWSManagedRulesLinuxRuleSet rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesLinuxRuleSet",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
    {
      name   = "WAF Blocked request with AWS-AWSManagedRulesAmazonIpReputationList rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesAmazonIpReputationList",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
    {
      name   = "WAF Blocked request with AWS-AWSManagedRulesCommonRuleSet rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesCommonRuleSet",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
    {
      name   = "WAF Blocked request with AWS-AWSManagedRulesSQLiRuleSet rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesSQLiRuleSet",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
    {
      name   = "WAF Blocked request with AWS-AWSManagedRulesUnixRuleSet rule"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesUnixRuleSet",
        Region = data.aws_region.current.name
      }
      period    = 60
      statistic = "count"
      threshold = 15
    },
  ]
  enable_insufficient_data_actions = false
  enable_ok_actions                = false
}
