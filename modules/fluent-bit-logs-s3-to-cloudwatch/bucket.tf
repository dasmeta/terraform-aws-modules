resource "aws_s3_bucket" "bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_ownership_controls" "disable_s3_acl" {
  count = var.create_bucket ? 1 : 0

  bucket = var.bucket_name

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
  depends_on = [
    aws_s3_bucket.bucket
  ]
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  policy = data.aws_iam_policy_document.allow_access_from_another_account[0].json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  count = var.create_bucket ? 1 : 0

  statement {
    principals {
      type        = "AWS"
      identifiers = var.assume_role_arn
    }

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.bucket[0].arn,
      "${aws_s3_bucket.bucket[0].arn}/*",
    ]
  }
}
