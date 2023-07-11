### Example 1. Simple example create waf. This example not set roles and doesn't have association.

```
module "waf_alb" {
  source                 = "dasmeta/modules/aws//modules/waf/"
  name                   = "test"

  visibility_config = {
    metric_name                = "test-waf"
  }
}
```

### Example 2 Simple example create waf for cloudfront and allow only one IP access to it. This example doesn't have cloudfront association. You should use the web_acl_id property on the cloudfront_distribution instead.

```
module "waf_cloudfront" {
  source = "dasmeta/modules/aws//modules/waf/"
  name   = "test_cloudfront"

  scope                  = "CLOUDFRONT"
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "test-waf"
    sampled_requests_enabled   = true
  }

  allow_default_action = false
  whitelist_ips = [
    "XXX.XXX.XXX.XXX/32" # Your super IP here
  ]
}
```

### Example 3. Create WAF and association alb.

```
module "waf_alb" {
  source = "dasmeta/modules/aws//modules/waf/"
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
  source = "dasmeta/modules/aws//modules/waf/"
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
  source = "dasmeta/modules/aws//modules/waf/"
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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_waf"></a> [waf](#module\_waf) | umotif-public/waf-webaclv2/aws | 4.6.1 |

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.whitelist_ip_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | Application Load Balancer ARN | `string` | `""` | no |
| <a name="input_alb_arn_list"></a> [alb\_arn\_list](#input\_alb\_arn\_list) | Application Load Balancer ARN list | `list(string)` | `[]` | no |
| <a name="input_allow_default_action"></a> [allow\_default\_action](#input\_allow\_default\_action) | Set to true for WAF to allow requests by default. Set to false for WAF to block requests by default. | `bool` | `true` | no |
| <a name="input_create_alb_association"></a> [create\_alb\_association](#input\_create\_alb\_association) | Whether to create alb association with WAF web acl | `bool` | `false` | no |
| <a name="input_enable_default_rule"></a> [enable\_default\_rule](#input\_enable\_default\_rule) | Enabled default protection rules(AWSManagedRulesCommonRuleSet,AWSManagedRulesAmazonIpReputationList,AWSManagedRulesKnownBadInputsRuleSet,AWSManagedRulesLinuxRuleSet,AWSManagedRulesSQLiRuleSet,AWSManagedRulesUnixRuleSet) | `bool` | `true` | no |
| <a name="input_enable_whitelist"></a> [enable\_whitelist](#input\_enable\_whitelist) | An temporary solution for case when one want to remove/disable IP whitelist without removing whitelist\_ids list, as it will fail to remove in use resources | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | List of WAF rules. | `any` | `[]` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider. | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of WAF rules. | `any` | `{}` | no |
| <a name="input_visibility_config"></a> [visibility\_config](#input\_visibility\_config) | Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration | `any` | <pre>{<br>  "metric_name": "test-waf-setup-waf-main-metrics"<br>}</pre> | no |
| <a name="input_whitelist_ips"></a> [whitelist\_ips](#input\_whitelist\_ips) | List of IPs to whitelist. NOTE that this is going to priority 1 so when you pass this list make sure that var.rules list do not contain priority=1 rule | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_arn"></a> [web\_acl\_arn](#output\_web\_acl\_arn) | n/a |
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
