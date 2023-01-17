data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id        = var.account_id == "" ? data.aws_caller_identity.current.account_id : var.account_id
  cloudtrail_region = var.cloudtrail_region == "" ? data.aws_region.current.name : var.cloudtrail_region
}
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

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
      target_prefix = "log/${var.bucket_name}"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "s3" {
  bucket = aws_s3_bucket.bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
              {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com",
                "AWS" : "${var.account_id}"
            },
            "Action": ["s3:GetBucketAcl","s3:ListBucket"],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com",
                "AWS" : "${var.account_id}"
            },
            "Action": ["s3:PutObject","s3:PutObjectAcl"],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ],
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "aws:SourceArn": "arn:aws:cloudtrail:${local.cloudtrail_region}:${local.account_id}:trail/${var.cloudtrail_name}"
                }
            }
        }
    ]
}
POLICY
}
