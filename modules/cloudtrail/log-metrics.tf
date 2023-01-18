locals {
  metrics_namespace = "LogBasedMetrics"
  metrics_patterns_mapping = {
    "iam-user-creation-or-deletion" = {
      name       = "IAM-user-creation-or-deletion"
      pattern    = "{ ($.eventName = CreateUser) || ($.eventName = DeleteUser)}"
      dimensions = {}
    },
    "iam-role-creation-or-deletion" = {
      name       = "IAM-role-creation-or-deletion"
      pattern    = "{ ($.eventName = CreateRole) || { ($.eventName = DeleteRole) }"
      dimensions = {}
    },
    "iam-policy-changes" = {
      name       = "IAM-policy-changes"
      pattern    = "{ $.eventName = PutUserPolicy || $.eventName = PutRolePolicy }"
      dimensions = {}
    },
    "s3-creation-or-deletion" = {
      name       = "S3-bucket-creation-or-deletion"
      pattern    = "{ $.eventName = CreateBucket || $.eventName = DeleteBucket }"
      dimensions = {}
    },
    "root-account-usage" = {
      name       = "Root-account-usage"
      pattern    = "{ $.userIdentity.type = Root }"
      dimensions = {}
    },
    "elastic-ip-association-and-disassociation" = {
      name       = "Elastic-IP-association-and-disassociation"
      pattern    = "{ $.eventName = AssociateAddress || $.eventName = DisassociateAddress }"
      dimensions = {}
    },
    "elastic-network-attachment-or-detachment" = {
      name       = "ENI-attachment-or-detachment"
      pattern    = "{ $.eventName = AttachNetworkInterface || $.eventName = DetachNetworkInterface }"
      dimensions = {}
    },
    "rds-creation-or-deletion" = {
      name       = "RDS-instance-creation-or-deletion"
      pattern    = "{ $.eventName = CreateDBInstance || $.eventName = DeleteDBInstance }"
      dimensions = {}
    },
    "cdn-creation-or-deletion" = {
      name       = "CDN-creation-or-deletion"
      pattern    = "{ $.eventName = CreateDistribution || $.eventName = DeleteDistribution }"
      dimensions = {}
    },
    "lambda-creation-or-deletion" = {
      name       = "Lambda-creation-or-deletion"
      pattern    = "{ $.eventName = CreateFunction || $.eventName = DeleteFunction }"
      dimensions = {}
    },
    "elasticache-creation-or-deletion" = {
      name       = "Elasticache-creation-or-deletion"
      pattern    = "{ $.eventName = CreateCacheCluster || $.eventName = DeleteCacheCluster }"
      dimensions = {}
    },
    "sns-creation-or-deletion" = {
      name       = "SNS-creation-or-deletion"
      pattern    = "{ $.eventName = CreateTopic || $.eventName = DeleteTopic }"
      dimensions = {}
    },
    "sqs-creation-or-deletion" = {
      name       = "SQS-creation-or-deletion"
      pattern    = "{ $.eventName = CreateQueue || $.eventName = DeleteQueue }"
      dimensions = {}
    },
    "ec2-launch-or-termination" = {
      name       = "EC2-instance-launch-or-termination"
      pattern    = "{ $.eventName = RunInstances || $.eventName = TerminateInstances }"
      dimensions = {}
    },
    "elasticsearch-creation-or-deletion" = {
      name       = "Elasticsearch-domain-creation-or-deletion"
      pattern    = "{ $.eventName = CreateElasticsearchDomain || $.eventName = DeleteElasticsearchDomain }"
      dimensions = {}
    },
    "elb-creation-or-deletion" = {
      name       = "ELB-creation-or-deletion"
      pattern    = "{ $.eventName = CreateLoadBalancer || $.eventName = DeleteLoadBalancer }"
      dimensions = {}
    },
  }
}

module "log_metric_filter" {
  source  = "dasmeta/monitoring/aws//modules/cloudwatch-log-based-metrics"
  version = "1.3.9"

  metrics_patterns  = [for name in var.alerts.events : local.metrics_patterns_mapping[name]]
  log_group_name    = var.cloud_watch_logs_group_name
  metrics_namespace = local.metrics_namespace

  depends_on = [
    aws_cloudtrail.cloudtrail
  ]
}
