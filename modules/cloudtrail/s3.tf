resource "aws_s3_bucket" "s3" {
  count = var.create_s3_bucket ? 1 : 0

  bucket        = local.s3_bucket_name
  force_destroy = var.bucket_protection.force_destroy
}

locals {
  s3_governance_enabled = var.bucket_protection.governance_retention_years > 0
}

resource "aws_s3_bucket_versioning" "s3" {
  count = var.create_s3_bucket && var.bucket_protection.versioning_enabled ? 1 : 0

  bucket = aws_s3_bucket.s3[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

# Use the standalone configuration to enable Object Lock on an existing bucket.
# Setting object_lock_enabled on aws_s3_bucket itself can force replacement.
resource "aws_s3_bucket_object_lock_configuration" "s3" {
  count = var.create_s3_bucket && local.s3_governance_enabled ? 1 : 0

  bucket              = aws_s3_bucket.s3[0].id
  object_lock_enabled = "Enabled"

  rule {
    default_retention {
      mode  = "GOVERNANCE"
      years = var.bucket_protection.governance_retention_years
    }
  }

  depends_on = [aws_s3_bucket_versioning.s3]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms" {
  count = var.kms_key_arn != null ? 1 : 0

  bucket = aws_s3_bucket.s3[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_policy" "s3" {
  count = var.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.s3[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      {
        Sid       = "AWSCloudTrailAclCheck"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.s3[0].arn
      },
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = ["cloudtrail.amazonaws.com", "config.amazonaws.com"] }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.s3[0].arn}/*"
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      }
      ], local.s3_governance_enabled ? [merge({
        Sid       = "DenyGovernanceBypassExceptEmergencyRoles"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:BypassGovernanceRetention"
        Resource  = "${aws_s3_bucket.s3[0].arn}/*"
        }, length(var.bucket_protection.governance_bypass_role_arns) > 0 ? {
        Condition = { ArnNotEquals = { "aws:PrincipalArn" = var.bucket_protection.governance_bypass_role_arns } }
    } : {})] : [])
  })
}
