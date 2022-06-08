# Create S3 bucket for CloudTrail and enable lambda for move data to CloudWatch

```
module "cloudtrail-to-s3-to-cloudwatch" {
  source                         = "./cloudtrail-s3-to-cloudwatch"
  bucket_name                    = "cloudtrail-log-bucket"
  create_lambda_s3_to_cloudwatch = true
  // If you want access another account to write bucket you can set account id , if you use cloudtrail and s3 bucket same account you shouldn't set this variable
  account_id                     = "56**168"
  cloudtrail_name                = "cloudtrail"
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

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
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `"test-fluent-bit-bla"` | no |
| <a name="input_cloudtrail_name"></a> [cloudtrail\_name](#input\_cloudtrail\_name) | n/a | `string` | n/a | yes |
| <a name="input_cloudtrail_region"></a> [cloudtrail\_region](#input\_cloudtrail\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_create_lambda_s3_to_cloudwatch"></a> [create\_lambda\_s3\_to\_cloudwatch](#input\_create\_lambda\_s3\_to\_cloudwatch) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->