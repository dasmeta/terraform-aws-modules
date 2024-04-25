module "alerts" {
  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.6.0"

  count = var.alarms.enabled ? 1 : 0

  sns_topic = var.alarms.sns_topic
  alerts = [
    {
      name   = "WAF: High Volume of Blocked Requests Across All Rules on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "ALL",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.all.period, 60)
      statistic = try(var.alarms.custom_values.all.statistic, "count")
      threshold = try(var.alarms.custom_values.all.threshold, 100)
    },
    {
      name   = "WAF: High Blocks for Known Bad Inputs on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesKnownBadInputsRuleSet",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.knownbadinputsruleset.period, 60)
      statistic = try(var.alarms.custom_values.knownbadinputsruleset.statistic, "count")
      threshold = try(var.alarms.custom_values.knownbadinputsruleset.threshold, 100)
    },
    {
      name   = "WAF: Increased Blocking Activity for Linux Rules on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesLinuxRuleSet",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.linuxrulesset.period, 60)
      statistic = try(var.alarms.custom_values.linuxrulesset.statistic, "count")
      threshold = try(var.alarms.custom_values.linuxrulesset.threshold, 100)
    },
    {
      name   = "WAF: High Block Rate for Poor IP Reputation on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesAmazonIpReputationList",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.ipreputationlist.period, 60)
      statistic = try(var.alarms.custom_values.ipreputationlist.statistic, "count")
      threshold = try(var.alarms.custom_values.ipreputationlist.threshold, 100)
    },
    {
      name   = "WAF: Consistent Blocking Activity for Common Rules on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesCommonRuleSet",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.commonruleset.period, 60)
      statistic = try(var.alarms.custom_values.commonruleset.statistic, "count")
      threshold = try(var.alarms.custom_values.commonruleset.threshold, 100)
    },
    {
      name   = "WAF: Elevated Blocking for SQL Injection Attacks on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesSQLiRuleSet",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.sqliruleset.period, 60)
      statistic = try(var.alarms.custom_values.sqliruleset.statistic, "count")
      threshold = try(var.alarms.custom_values.sqliruleset.threshold, 100)
    },
    {
      name   = "WAF: Rising Blocking Activity for Unix Rules on ${var.name}"
      source = "AWS/WAFV2/BlockedRequests"
      filters = {
        WebACL = var.name,
        Rule   = "AWS-AWSManagedRulesUnixRuleSet",
        Region = data.aws_region.current.name
      }
      period    = try(var.alarms.custom_values.unixruleset.period, 60)
      statistic = try(var.alarms.custom_values.unixruleset.statistic, "count")
      threshold = try(var.alarms.custom_values.unixruleset.threshold, 100)
    },
  ]
  enable_insufficient_data_actions = false
  enable_ok_actions                = false
}
