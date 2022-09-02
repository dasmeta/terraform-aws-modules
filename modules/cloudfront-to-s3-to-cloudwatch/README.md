# Create S3 bucket for CloudFront and enable lambda for move data to CloudWatch

```
module "cloudfront-lambda" {
  source      = "dasmeta/modules/aws//modules/cloudfront-to-s3-to-cloudwatch"
  bucket_name = "cloudfront-access-log-test-123232234232313"
  account_id  = "56**8"
}
```

# Create lambda for move CloudFront s3 logs to CloudWatch

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | ~> 4.16 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | ~> 4.16 |

## Modules

| Name                                                                                                                       | Source                           | Version |
| -------------------------------------------------------------------------------------------------------------------------- | -------------------------------- | ------- |
| <a name="module_cloudfront_logs_to_cloudwatch"></a> [cloudfront_logs_to_cloudwatch](#module_cloudfront_logs_to_cloudwatch) | ./cloudfront-to-s3-to-cloudwatch | n/a     |

## Resources

| Name                                                                                                                                  | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)      | resource    |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)         | resource    |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                         | resource    |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource    |
| [aws_s3_bucket_policy.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)               | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)         | data source |
| [aws_s3_bucket.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket)                    | data source |

## Inputs

| Name                                                                     | Description                                                                                                         | Type     | Default | Required |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_account_id"></a> [account_id](#input_account_id)          | Remote AWS Account id to stream logs to. If left empty current account will be used.                                | `string` | `""`    |    no    |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name)       | Name of the bucket module will create for CloudFront to stream logs to. Will default to account_id-cloudfront-logs. | `string` | `""`    |    no    |
| <a name="input_create_bucket"></a> [create_bucket](#input_create_bucket) | Defines if the module should create the bucket or use one specified.                                                | `bool`   | `true`  |    no    |
| <a name="input_create_lambda"></a> [create_lambda](#input_create_lambda) | If enabled lambda will be created which will stream logs from S3 into CloudWatch.                                   | `bool`   | `true`  |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
