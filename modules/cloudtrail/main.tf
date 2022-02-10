data "aws_caller_identity" "current" {}

locals {
  s3_bucket_name = "${var.name}-cloud-trial-bucket"
  s3_key_prefix  = "cloudtrial"
}
resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.name
  s3_bucket_name                = aws_s3_bucket.s3.id
  s3_key_prefix                 = local.s3_key_prefix
  include_global_service_events = var.include_global_service_events
  enable_log_file_validation    = var.enable_log_file_validation
  is_organization_trail         = var.is_organization_trail
  is_multi_region_trail         = var.is_multi_region_trail
  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn
  enable_logging                = var.enable_logging
  sns_topic_name                = var.sns_topic_name

  dynamic "event_selector" {
    for_each = var.event_selector
    content {
      include_management_events = lookup(event_selector.value, "include_management_events", null)
      read_write_type           = lookup(event_selector.value, "read_write_type", null)

      dynamic "data_resource" {
        for_each = lookup(event_selector.value, "data_resource", [])
        content {
          type   = data_resource.value.type
          values = data_resource.value.values
        }
      }
    }
  }
}

resource "aws_s3_bucket" "s3" {
  bucket        = local.s3_bucket_name
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.s3_bucket_name}/${local.s3_key_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
