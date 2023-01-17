data "aws_caller_identity" "current" {}

locals {
  account_id  = var.account_id == "" ? data.aws_caller_identity.current.account_id : var.account_id
  bucket_name = var.bucket_name == "" ? "${local.account_id}-cloudfront-logs" : var.bucket_name
}

resource "aws_s3_bucket" "bucket" {
  count = var.create_bucket ? 1 : 0

  bucket = local.bucket_name
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
      target_prefix = "log/${local.bucket_name}"
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
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
              {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "AWS" : "${local.account_id}"
            },
            "Action":  [
                "s3:PutObject",
                "s3:ListBucket",
                "s3:GetBucketAcl",
                "s3:PutBucketAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${local.bucket_name}",
                "arn:aws:s3:::${local.bucket_name}/*"
            ]
        }
    ]
}
POLICY
}
