# module "monitoring_dashboard" {
#   source  = "dasmeta/monitoring/aws//modules/dashboard"
#   version = "1.7.0"

#   count = var.create_dashboard ? 1 : 0

#   name = var.name
#   rows = [
#     [
#       {
#         type = "text/title"
#         text = "WAF all requests"
#       },
#     ],
#     [
#       {
#         height = 4
#         width  = 24
#         type   = "custom",
#         title  = "ALLREQUEST/BLOCKED",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "ALL"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "ALL"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#     ],
#     [
#       {
#         type = "text/title"
#         text = "WAF rule requests"
#       }
#     ],
#     [
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesKnownBadInputsRuleSet",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesLinuxRuleSet",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesLinuxRuleSet"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesLinuxRuleSet"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesAmazonIpReputationList",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesAmazonIpReputationList"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesAmazonIpReputationList"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#     ],
#     [
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesCommonRuleSet",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesCommonRuleSet"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesCommonRuleSet"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesSQLiRuleSet",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesSQLiRuleSet"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesSQLiRuleSet"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#       {
#         width = 8
#         type  = "custom",
#         title = "AWSManagedRulesUnixRuleSet",
#         metrics : [
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "BlockedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesUnixRuleSet"
#             Region          = data.aws_region.current.name
#           },
#           {
#             MetricNamespace = "AWS/WAFV2"
#             MetricName      = "AllowedRequests"
#             WebACL          = var.name
#             Rule            = "AWS-AWSManagedRulesUnixRuleSet"
#             Region          = data.aws_region.current.name
#           }
#         ]
#       },
#     ],
#   ]
# }
