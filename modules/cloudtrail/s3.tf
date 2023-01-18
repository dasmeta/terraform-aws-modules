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
