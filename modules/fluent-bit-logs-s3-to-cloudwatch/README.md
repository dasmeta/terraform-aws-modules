# Create S3 bucket for FluentBit and enable lambda for move data to CloudWatch

```
module "s3-to-cloudwatch" {
  source                         = "./s3-to-cloudwatch"
  bucket_name                    = "test-fluent-bit-bla2"
  assume_role_arn                = ["arn:aws:iam::565580475168:role/dasmeta-test-new2-fluent-bit"]
}
```

# Create S3 bucket only for FluentBit and disable lambda 

```
module "s3-to-cloudwatch" {
  source                         = "./s3-to-cloudwatch"
  bucket_name                    = "test-fluent-bit-bla2"
  create_lambda_s3_to_cloudwatch = false
  assume_role_arn                = ["arn:aws:iam::565580475168:role/dasmeta-test-new2-fluent-bit"]
}
```