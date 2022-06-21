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
