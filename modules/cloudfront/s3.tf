module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
#   version = var.s3_version
  # insert the 5 required variables here

  bucket = var.s3_bucket_name
  acl    = var.s3_bucket_acl

  # Allow deletion of non-empty bucket
  force_destroy = true

  object_lock_configuration = { 
      object_lock_enabled = "Enabled"
  }

  attach_elb_log_delivery_policy = true  # Required for ALB logs
  attach_lb_log_delivery_policy  = true  # Required for ALB/NLB logs
}


# resource "aws_s3_bucket_object" "examplebucket_object" {
#   key    = "1.jpeg"
#   bucket = "terraform-module-vik-2"
#   content = "important.txt"

#   force_destroy = true
# }
