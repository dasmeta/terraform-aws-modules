locals {
  metrics_patterns_mapping = {
    "iam-user" = {
      name       = "IAM-user-creation-or-deletion"
      pattern    = "{ ($.eventName = CreateUser) || ($.eventName = DeleteUser)}"
      dimensions = {}
    },
    "iam-role" = {
      name       = "IAM-role-creation-or-deletion"
      pattern    = "{ ($.eventName = CreateRole) || { ($.eventName = DeleteRole) }"
      dimensions = {}
    },
    "iam-policy" = {
      name       = "IAM-policy-changes"
      pattern    = "{ $.eventName = PutUserPolicy || $.eventName = PutRolePolicy }"
      dimensions = {}
    },
    "s3" = {
      name       = "S3-bucket-creation-or-deletion"
      pattern    = "{ $.eventName = CreateBucket || $.eventName = DeleteBucket }"
      dimensions = {}
    },
    "root-account" = {
      name       = "Root-account-usage"
      pattern    = "{ $.userIdentity.type = Root }"
      dimensions = {}
    },
    "elastic-ip" = {
      name       = "Elastic-IP-association-and-disassociation"
      pattern    = "{ $.eventName = AssociateAddress || $.eventName = DisassociateAddress }"
      dimensions = {}
    },
    "elastic-network" = {
      name       = "ENI-attachment-or-detachment"
      pattern    = "{ $.eventName = AttachNetworkInterface || $.eventName = DetachNetworkInterface }"
      dimensions = {}
    },
    "rds" = {
      name       = "RDS-instance-creation-or-deletion"
      pattern    = "{ $.eventName = CreateDBInstance || $.eventName = DeleteDBInstance }"
      dimensions = {}
    },
    "cdn" = {
      name       = "CDN-creation-or-deletion"
      pattern    = "{ $.eventName = CreateDistribution || $.eventName = DeleteDistribution }"
      dimensions = {}
    },
    "lambda" = {
      name       = "Lambda-creation-or-deletion"
      pattern    = "{ $.eventName = CreateFunction || $.eventName = DeleteFunction }"
      dimensions = {}
    },
    "elasticache" = {
      name       = "Elasticache-creation-or-deletion"
      pattern    = "{ $.eventName = CreateCacheCluster || $.eventName = DeleteCacheCluster }"
      dimensions = {}
    },
    "sns" = {
      name       = "SNS-creation-or-deletion"
      pattern    = "{ $.eventName = CreateTopic || $.eventName = DeleteTopic }"
      dimensions = {}
    },
    "sqs" = {
      name       = "SQS-creation-or-deletion"
      pattern    = "{ $.eventName = CreateQueue || $.eventName = DeleteQueue }"
      dimensions = {}
    },
    "ec2" = {
      name       = "EC2-instance-launch-or-termination"
      pattern    = "{ $.eventName = RunInstances || $.eventName = TerminateInstances }"
      dimensions = {}
    },
    "elasticsearch" = {
      name       = "Elasticsearch-domain-creation-or-deletion"
      pattern    = "{ $.eventName = CreateElasticsearchDomain || $.eventName = DeleteElasticsearchDomain }"
      dimensions = {}
    },
    "elb" = {
      name       = "ELB-creation-or-deletion"
      pattern    = "{ $.eventName = CreateLoadBalancer || $.eventName = DeleteLoadBalancer }"
      dimensions = {}
    },
  }
}

module "log_metric_filter" {
  source  = "dasmeta/monitoring/aws//modules/cloudwatch-log-based-metrics"
  version = "1.3.9"

  count = var.log_metrics.enabled ? 1 : 0

  metrics_patterns  = [for name in var.log_metrics.enabled_metrics : local.metrics_patterns_mapping[name]]
  log_group_name    = "${aws_cloudtrail.cloudtrail.name}-cloudtrail-logs"
  metrics_namespace = var.log_metrics.metrics_namespace

  depends_on = [
    aws_cloudtrail.cloudtrail
  ]
}
