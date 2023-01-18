module "cloudfront-lambda" {
  source        = "dasmeta/modules/aws//modules/cloudfront-to-s3-to-cloudwatch"
  bucket_name   = "cloudfront-access-log-test-123232234232313"
  account_id    = "56**8"
  create_bucket = false
}
