locals {
  default_rules = [
    #  Contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities,
    #  including those described in OWASP publications.
    {
      name            = "AWS-AWSManagedRulesCommonRuleSet"
      priority        = "0"
      override_action = var.mode == "block" ? "none" : "count"
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
        sampled_requests_enabled   = true
      }
      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    },
    # This group contains rules that are based on Amazon threat intelligence.
    # This is useful if you would like to block sources associated with bots or other threats
    {
      name            = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority        = 1
      override_action = var.mode == "block" ? "none" : "count"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
        sampled_requests_enabled   = true
      }
    },
    # Contains rules that allow you to block request patterns that are known to be invalid and are associated with exploitation or discovery of vulnerabilities.
    # This can help reduce the risk of a malicious actor discovering a vulnerable application.
    {
      name            = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority        = 2
      override_action = var.mode == "block" ? "none" : "count"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
        sampled_requests_enabled   = true
      }
    },
    # Contains rules that block request patterns associated with exploitation of vulnerabilities specific to Linux, including LFI attacks.
    # This can help prevent attacks that expose file contents or execute code for which the attacker should not have had access.
    {
      name            = "AWS-AWSManagedRulesLinuxRuleSet"
      priority        = 3
      override_action = var.mode == "block" ? "none" : "count"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
        sampled_requests_enabled   = true
      }
    },
    # Contains rules that allow you to block request patterns associated with exploitation of SQL databases, like SQL injection attacks.
    # This can help prevent remote injection of unauthorized queries
    {
      name            = "AWS-AWSManagedRulesSQLiRuleSet"
      priority        = 4
      override_action = var.mode == "block" ? "none" : "count"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
        sampled_requests_enabled   = true
      }
    },
    # Contains rules that block request patterns associated with exploiting vulnerabilities specific to POSIX/POSIX-like OS, including LFI attacks.
    # This can help prevent attacks that expose file contents or execute code for which access should not been allowed.
    {
      name            = "AWS-AWSManagedRulesUnixRuleSet"
      priority        = 5
      override_action = var.mode == "block" ? "none" : "count"
      managed_rule_group_statement = {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-AWSManagedRulesUnixRuleSet"
        sampled_requests_enabled   = true
      }
    },
  ]
}
