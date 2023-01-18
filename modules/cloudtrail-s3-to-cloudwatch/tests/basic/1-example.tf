module "cloudtrail-s3-to-cloudwatch-minimal" {
  source = "../../"

  bucket_name                    = "cloudtrail-log-bucket"
  create_lambda_s3_to_cloudwatch = true
  // If you want access another account to write bucket you can set account id , if you use cloudtrail and s3 bucket same account you shouldn't set this variable
  account_id      = "56**168"
  cloudtrail_name = "cloudtrail"
}
