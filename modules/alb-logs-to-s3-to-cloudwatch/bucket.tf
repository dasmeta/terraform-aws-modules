locals {}

data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {
  region = var.region
}


locals {
  account_id = var.account_id == "" ? data.aws_caller_identity.current.account_id : var.account_id
}

module "s3_log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"
  count   = var.create_alb_log_bucket ? 1 : 0

  bucket                         = var.alb_log_bucket_name
  force_destroy                  = true
  attach_elb_log_delivery_policy = true
  block_public_acls              = true
  block_public_policy            = true
  ignore_public_acls             = true
  restrict_public_buckets        = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = [
    {
      id      = "expire-old-logs"
      enabled = true
      prefix  = "/"

      expiration = {
        days = var.log_retention_days
      }
    }
  ]
}
