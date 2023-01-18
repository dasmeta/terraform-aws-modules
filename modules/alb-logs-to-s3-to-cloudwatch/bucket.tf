locals {}

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {
  region = var.region
}


locals {
  account_id = var.account_id == "" ? data.aws_caller_identity.current.account_id : var.account_id
}

resource "aws_s3_bucket" "bucket" {
  count = var.create_alb_log_bucket ? 1 : 0

  bucket = var.alb_log_bucket_name
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
      target_prefix = "log/${var.alb_log_bucket_name}"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.bucket[0].id

  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  block_public_policy     = true
}

resource "aws_s3_bucket_policy" "s3" {
  count = var.create_alb_log_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.alb_log_bucket_name}/*"
    }
  ]
}
POLICY
}
