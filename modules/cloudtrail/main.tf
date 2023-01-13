data "aws_caller_identity" "current" {}

locals {
  s3_bucket_name = "${var.name}-cloud-trail-bucket"
}

resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.name
  s3_bucket_name                = var.create_s3_bucket ? local.s3_bucket_name : var.bucket_name
  s3_key_prefix                 = var.s3_key_prefix
  include_global_service_events = var.include_global_service_events
  enable_log_file_validation    = var.enable_log_file_validation
  is_organization_trail         = var.is_organization_trail
  is_multi_region_trail         = var.is_multi_region_trail
  cloud_watch_logs_group_arn    = var.enable_cloudwatch_logs ? "${aws_cloudwatch_log_group.logs[0].arn}:*" : var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.enable_cloudwatch_logs ? aws_iam_role.cloudtrail_roles[0].arn : var.cloud_watch_logs_role_arn
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

  dynamic "insight_selector" {
    for_each = var.insight_selectors

    content {
      insight_type = insight_selector.value
    }
  }

  depends_on = [
    aws_s3_bucket.s3
  ]
}

resource "aws_s3_bucket" "s3" {
  count = var.create_s3_bucket ? 1 : 0

  bucket        = local.s3_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "s3" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.s3[0].id
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
            "Resource": "${aws_s3_bucket.s3[0].arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.s3[0].arn}/${var.s3_key_prefix}/*",
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
