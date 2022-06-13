<!-- BEGIN_TF_DOCS -->
# Why
Create S3 bucket for CloudTrail and lambda to push data to CloudWatch

## Examples
Minimal Setup
```terraform
module "cloudtrail-s3-to-cloudwatch-minimal" {
  source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
  version = "0.32.0"

  bucket_name                    = "cloudtrail-log-bucket"
  create_lambda_s3_to_cloudwatch = true
  // If you want access another account to write bucket you can set account id , if you use cloudtrail and s3 bucket same account you shouldn't set this variable
  account_id                     = "56**168"
  cloudtrail_name                = "cloudtrail"
}
```
Disable Lambda - just bucket
```terraform
module "cloudtrail-s3-to-cloudwatch-no-lambda" {
  source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
  version = "0.32.0"

  bucket_name                    = "cloudtrail-log-bucket"
  cloudtrail_name                = "cloudtrail"
  create_lambda_s3_to_cloudwatch = false
}
```
Different AWS Account (cross account log streaming)
```terraform
module "cloudtrail-s3-to-cloudwatch-different-account" {
  source  = "dasmeta/modules/aws//modules/cloudtrail-s3-to-cloudwatch"
  version = "0.32.0"

  bucket_name                    = "cloudtrail-log-bucket"
  cloudtrail_name                = "cloudtrail"
  account_id                     = "56**168"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_logs_to_cloudwatch"></a> [s3\_logs\_to\_cloudwatch](#module\_s3\_logs\_to\_cloudwatch) | ./cloudtrail-log-to-cloudwatch | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS Account ID logs will be pushed from. Will take default account\_id if nothing provided. | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Whatever bucket CloudTrail logs will be pushed into. Works cross account. | `string` | `"test-fluent-bit-bla"` | no |
| <a name="input_cloudtrail_name"></a> [cloudtrail\_name](#input\_cloudtrail\_name) | CloudTrail name logs will be pushed from. Used to setup permissions on Bucket to accept logs from. | `string` | n/a | yes |
| <a name="input_cloudtrail_region"></a> [cloudtrail\_region](#input\_cloudtrail\_region) | The region CloudTrail reside. Used to to setup permissions on Bucket to accept logs from. Defaults to current region if non provided. | `string` | `""` | no |
| <a name="input_create_lambda_s3_to_cloudwatch"></a> [create\_lambda\_s3\_to\_cloudwatch](#input\_create\_lambda\_s3\_to\_cloudwatch) | Will create Lambda which will push s3 logs into CloudWatch. | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->