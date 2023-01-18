module "s3-to-cloudwatch" {
  source                         = "../../"
  bucket_name                    = "test-fluent-bit-bla2"
  create_lambda_s3_to_cloudwatch = true
  assume_role_arn                = ["arn:aws:iam::5*68:role/eks-cluster-fluent-bit"]
}
