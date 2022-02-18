
### Example  1. Simple example create waf. This example not set roles and doesn't have association.

```
module "waf_alb" {
  source                 = "dasmeta/modules/aws//modules/"
  name                   = "test"

  visibility_config = {
    metric_name                = "test-waf"
  }
}
```

### Example 2 Simple example create waf for cloudfront. This example nor set roles and doesn't have cloudfront association.

```
module "waf_cloudfront" {
  source = "dasmeta/modules/aws//modules/"
  name   = "test_cloudfront"

  scope                  = "CLOUDFRONT"
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "test-waf"
    sampled_requests_enabled   = true
  }
}
```

### Example 3. Create WAF and association alb.

```
module "waf_alb" {
  source = "dasmeta/modules/aws//modules/"
  name   = "test"

  create_alb_association = true

  alb_arn = "arn:aws:elasticloadbalancing:us-east-1:*:loadbalancer/"
  visibility_config = {
    metric_name = "test-waf"
  }
}

```

### Example 4. Create WAF and association alb using alb_arn_list variable.

```
module "waf_alb" {
  source = "dasmeta/modules/aws//modules/"
  name   = "test"

  create_alb_association = true

  alb_arn_list = ["arn:aws:elasticloadbalancing:us-east-1:*:loadbalancer/"]
  visibility_config = {
    metric_name = "test-waf"
  }
}

```

### Example 5 . Create WAF, set rules and association alb.

```
module "waf_alb" {
  source = "dasmeta/modules/aws//modules/"
  name   = "test"

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_BODY",
          "GenericRFI_QUERYARGUMENTS"
        ]
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
  ]

  create_alb_association = true
  alb_arn_list           = ["arn:aws:elasticloadbalancing:us-east-1:*:loadbalancer/"]
  visibility_config = {
    metric_name = "test-waf"
  }
}
```


### Rule Type 

```
{
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name                = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_BODY",
          "GenericRFI_QUERYARGUMENTS"
        ]
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesPHPRuleSet-rule-3"
      priority = "3"

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesPHPRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    },

    # Byte Match Rule example
    # Refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#byte-match-statement
    
    {
      name     = "ByteMatchRule-4"
      priority = "4"

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "ByteMatchRule-metric"
        sampled_requests_enabled   = false
      }

      byte_match_statement = {
        field_to_match = {
          uri_path = "{}"
        }
        positional_constraint = "STARTS_WITH"
        search_string         = "/path/to/match"
        priority              = 0
        type                  = "NONE"
      }
    },
    
    # Geo Match Rule example
    {
      name     = "GeoMatchRule-5"
      priority = "5"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "GeoMatchRule-metric"
        sampled_requests_enabled   = false
      }

      geo_match_statement = {
        country_codes = ["NL", "GB", "US"]
      }
    },

    # IP Set Rule example
    {
      name     = "IpSetRule-6"
      priority = "6"

      action = "allow"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IpSetRule-metric"
        sampled_requests_enabled   = false
      }

      ip_set_reference_statement = {
        arn = "arn:aws:wafv2:eu-west-1:111122223333:regional/ipset/ip-set-test/a1bcdef2-1234-123a-abc0-1234a5bc67d8"
      }
    },

    # IP Rate Based Rule example
    {
      name     = "IpRateBasedRule-7"
      priority = "7"

      action = "block"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "IpRateBasedRule-metric"
        sampled_requests_enabled   = false
      }

      rate_based_statement = {
        limit              = 100
        aggregate_key_type = "IP"
        # Optional scope_down_statement to refine what gets rate limited
        scope_down_statement = {
          not_statement = {
            byte_match_statement = {
              field_to_match = {
                uri_path = "{}"
              }
              positional_constraint = "STARTS_WITH"
              search_string         = "/path/to/match"
              priority              = 0
              type                  = "NONE"
            }
          }
        }
      }
    },

    # NOT rule example (can be applied to byte_match, geo_match, and ip_set rules)
    {
      name     = "NotByteMatchRule-8"
      priority = "8"

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "NotByteMatchRule-metric"
        sampled_requests_enabled   = false
      }

      not_statement {
        byte_match_statement = {
          field_to_match = {
            uri_path = "{}"
          }
          positional_constraint = "STARTS_WITH"
          search_string         = "/path/to/match"
          priority              = 0
          type                  = "NONE"
        }
      }
    },
    
    # Size constraint Rule example
    # Refer to https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#size-constraint-statement

    {
      name     = "BodySizeConstraint"
      priority = 0
      size_constraint_statement = {
        field_to_match = {
          body = "{}"
        }
        comparison_operator = "GT"
        size                = 8192
        priority            = 0
        type                = "NONE"
      }

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = true
        metric_name                = "BodySizeConstraint"
        sampled_requests_enabled   = true
      }
    }
```