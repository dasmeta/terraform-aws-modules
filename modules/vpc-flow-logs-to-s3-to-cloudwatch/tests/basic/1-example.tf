module "vpc-flow-logs-to-s3-to-cloudwatch" {
  source      = "dasmeta/modules/aws//modules/vpc-flow-logs-to-s3-to-cloudwatch"
  bucket_name = "test-vpn-logs-new"
  account_id  = "5******8"
}
