resource "aws_s3_bucket" "bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = var.bucket_name
  acl    = "private"

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
