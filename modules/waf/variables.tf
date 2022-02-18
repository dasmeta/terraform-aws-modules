variable "name" {
  type        = string
  description = "Name"
}
variable "alb_arn" {
  type        = string
  description = "Application Load Balancer ARN"
  default     = ""
}

variable "alb_arn_list" {
  type        = list(string)
  description = "Application Load Balancer ARN list"
  default     = []
}

variable "scope" {
  type        = string
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider."
  default     = "REGIONAL"
}

variable "create_alb_association" {
  type        = bool
  description = "Whether to create alb association with WAF web acl"
  default     = false
}
variable "allow_default_action" {
  type        = bool
  description = "Set to true for WAF to allow requests by default. Set to false for WAF to block requests by default."
  default     = true
}
variable "visibility_config" {
  type        = any
  description = "Visibility config for WAFv2 web acl. https://www.terraform.io/docs/providers/aws/r/wafv2_web_acl.html#visibility-configuration"
  default     = { metric_name = "test-waf-setup-waf-main-metrics" }
}
variable "rules" {
  type        = any
  description = "List of WAF rules."
  default     = []
}
variable "tags" {
  type        = any
  description = "List of WAF rules."
  default     = {}
}

# variable "name" {
#   type        = string
#   description = "Name"
#   default     = ""
# }

# variable "rules" {
#   type        = any
#   description = "All rules"
#   default = [{
#     name     = "rule-1"
#     priority = 1

#     override_action = {
#       count = {}
#     }

#     # statement = {
#     #   managed_rule_group_statement = {
#     #     name        = "AWSManagedRulesCommonRuleSet"
#     #     vendor_name = "AWS"

#     #     excluded_rule = {
#     #       name = "SizeRestrictions_QUERYSTRING"
#     #     }

#     #     excluded_rule = {
#     #       name = "NoUserAgent_HEADER"
#     #     }

#     #     scope_down_statement = {
#     #       geo_match_statement = {
#     #         country_codes = ["US", "NL"]
#     #       }
#     #     }
#     #   }
#     # }

#     # visibility_config = {
#     #   cloudwatch_metrics_enabled = false
#     #   metric_name                = "friendly-rule-metric-name"
#     #   sampled_requests_enabled   = false
#     # }
#   }]
# }



# variable "resource_arn" {
#   type        = string
#   description = "The Amazon Resource Name (ARN) of the resource to associate with the web ACL. This must be an ARN of an Application Load Balancer or an Amazon API Gateway stage."
#   default     = ""
# }

# variable "web_acl_arn" {
#   type        = string
#   description = "The Amazon Resource Name (ARN) of the Web ACL that you want to associate with the resource."
#   default     = ""
# }
