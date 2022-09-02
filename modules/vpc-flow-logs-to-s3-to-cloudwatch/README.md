# Create S3 bucket for VPC logs send logs other aws s3 bucket and lambda move data to CloudWatch

```
module "vpc-flow-logs-to-s3-to-cloudwatch" {
  source      = "dasmeta/modules/aws//modules/vpc-flow-logs-to-s3-to-cloudwatch"
  bucket_name = "test-vpn-logs-new"
  account_id  = "5******8"
}
```

# Create S3 bucket only for FluentBit and disable lambda

```
module "vpc-flow-logs-to-s3-to-cloudwatch" {
  source      = "dasmeta/modules/aws//modules/vpc-flow-logs-to-s3-to-cloudwatch"
  bucket_name = "test-vpn-logs-new"
  create_lambda_s3_to_cloudwatch = false
  account_id  = "5******8"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.16 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3_logs_to_cloudwatch"></a> [s3\_logs\_to\_cloudwatch](#module\_s3\_logs\_to\_cloudwatch) | ./vpc-logs-to-cloudwatch | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloudwatch_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `""` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | `""` | no |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | n/a | `bool` | `true` | no |
| <a name="input_create_lambda_s3_to_cloudwatch"></a> [create\_lambda\_s3\_to\_cloudwatch](#input\_create\_lambda\_s3\_to\_cloudwatch) | n/a | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
