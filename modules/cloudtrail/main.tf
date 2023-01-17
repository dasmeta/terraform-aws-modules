data "aws_caller_identity" "current" {}

locals {
  s3_bucket_name = "${var.name}-cloud-trail-bucket"
  s3_key_prefix  = "cloudtrial"
}
resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.name
  s3_bucket_name                = var.create_s3_bucket ? local.s3_bucket_name : var.bucket_name
  s3_key_prefix                 = local.s3_key_prefix
  include_global_service_events = var.include_global_service_events
  enable_log_file_validation    = var.enable_log_file_validation
  is_organization_trail         = var.is_organization_trail
  is_multi_region_trail         = var.is_multi_region_trail
  cloud_watch_logs_group_arn    = var.cloud_watch_logs_group_arn
  cloud_watch_logs_role_arn     = var.cloud_watch_logs_role_arn
  enable_logging                = var.enable_logging
  sns_topic_name                = var.sns_topic_name
  kms_key_id                    = var.kms_key_id

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
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = local.s3_bucket_name
  force_destroy = true
  versioning {
    enabled = var.enabled
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging
    content {
      target_bucket = logging.value["target_bucket"]
      target_prefix = "log/${local.s3_bucket_name}"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "s3" {
  count  = var.create_s3_bucket ? 1 : 0
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
