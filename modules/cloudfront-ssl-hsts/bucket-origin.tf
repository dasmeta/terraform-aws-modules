data "aws_s3_bucket" "origins" {
  for_each = { for key, origin in var.origins : origin.id => origin if try(origin.type, null) == "bucket" }

  bucket = each.value.domain_name
}

resource "aws_cloudfront_origin_access_identity" "this" {
  for_each = data.aws_s3_bucket.origins

  provider = aws.virginia
}

data "aws_iam_policy_document" "s3_policy" {
  for_each = data.aws_s3_bucket.origins

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${each.value.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this[each.key].iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cdn_access_policy" {
  for_each = data.aws_s3_bucket.origins

  bucket = each.value.id
  policy = data.aws_iam_policy_document.s3_policy[each.key].json
}
