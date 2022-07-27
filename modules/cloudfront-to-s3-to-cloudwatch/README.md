# Create S3 bucket for CloudFront and enable lambda for move data to CloudWatch
```
module "cloudfront-lambda" {
  source      = "dasmeta/modules/aws//modules/cloudfront-to-s3-to-cloudwatch"
  bucket_name = "cloudfront-access-log-test-123232234232313"
  account_id  = "56**8"
}
```

# Create lambda for move CloudFront s3 logs  to CloudWatch
```
module "cloudfront-lambda" {
  source      = "dasmeta/modules/aws//modules/cloudfront-to-s3-to-cloudwatch"
  bucket_name = "cloudfront-access-log-test-123232234232313"
  account_id  = "56**8"
  create_bucket = false
}
```

# Create s3 bucket for CloudFront
```
module "cloudfront-lambda" {
  source      = "dasmeta/modules/aws//modules/cloudfront-to-s3-to-cloudwatch"
  bucket_name = "cloudfront-access-log-test-123232234232313"
  create_lambda = false
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
| <a name="module_cloudfront_logs_to_cloudwatch"></a> [cloudfront\_logs\_to\_cloudwatch](#module\_cloudfront\_logs\_to\_cloudwatch) | ./cloudfront-to-s3-to-cloudwatch | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_s3_bucket.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | n/a | `bool` | `true` | no |
| <a name="input_create_lambda"></a> [create\_lambda](#input\_create\_lambda) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
