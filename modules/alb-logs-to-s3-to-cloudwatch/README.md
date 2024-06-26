# Create S3 bucket for ALB and enable lambda for move data to CloudWatch

```
module "alb-logs-lambda" {
  source              = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch/"
  alb_log_bucket_name = "alb-access-log-test-123232234232313"
  account_id          = "56**8"
}

```

# Create lambda for move ALB s3 logs to CloudWatch

```
module "alb-logs-lambda" {
  source              = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch/"
  alb_log_bucket_name = "alb-access-log-test-123232234232313"
  account_id  = "56**8"
  create_alb_log_bucket = false
}
```

# Create s3 bucket for ALB

```
module "alb-logs-lambda" {
  source              = "dasmeta/modules/aws//modules/alb-logs-to-s3-to-cloudwatch/"
  alb_log_bucket_name = "alb-access-log-test-123232234232313"
  create_lambda = false
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
| <a name="module_alb_logs_to_cloudwatch"></a> [alb\_logs\_to\_cloudwatch](#module\_alb\_logs\_to\_cloudwatch) | ./alb-to-s3-to-cloudwatch-lambda | n/a |
| <a name="module_s3_log_bucket"></a> [s3\_log\_bucket](#module\_s3\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_s3_bucket.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `""` | no |
| <a name="input_alb_log_bucket_name"></a> [alb\_log\_bucket\_name](#input\_alb\_log\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_alb_log_bucket_prefix"></a> [alb\_log\_bucket\_prefix](#input\_alb\_log\_bucket\_prefix) | n/a | `string` | `""` | no |
| <a name="input_create_alb_log_bucket"></a> [create\_alb\_log\_bucket](#input\_create\_alb\_log\_bucket) | wether or no to create alb s3 logs bucket | `bool` | `true` | no |
| <a name="input_create_lambda"></a> [create\_lambda](#input\_create\_lambda) | n/a | `bool` | `true` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log Retention days for s3 | `number` | `7` | no |
| <a name="input_region"></a> [region](#input\_region) | Default region | `string` | `"us-east-1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
