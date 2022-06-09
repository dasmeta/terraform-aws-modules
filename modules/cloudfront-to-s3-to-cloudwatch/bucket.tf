data "aws_caller_identity" "current" {}

locals {
  account_id = var.account_id == "" ? data.aws_caller_identity.current.account_id : var.account_id
}

resource "aws_s3_bucket" "bucket" {
  count = var.create_bucket ? 1 : 0

  bucket = var.bucket_name
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
                "arn:aws:s3:::${var.bucket_name}",
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
POLICY
}
