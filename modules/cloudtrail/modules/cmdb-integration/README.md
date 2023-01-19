# cloudfront-to-s3-to-cloudwatch

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | 4.7.1 |
| <a name="module_topic"></a> [topic](#module\_topic) | dasmeta/sns/aws//modules/topic | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.destination_on_success](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_function_event_invoke_config.destination](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function_event_invoke_config) | resource |
| [aws_lambda_permission.s3_permission_to_trigger_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.incoming](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_iam_policy_document.destination_on_success](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | S3 bucket for s3 subscription | `string` | n/a | yes |
| <a name="input_cmdb_integration"></a> [cmdb\_integration](#input\_cmdb\_integration) | CMDB Integration Configs | <pre>object({<br>    config = optional(object({<br>      subscriptions = optional(list(object({<br>        protocol               = optional(string, null)<br>        endpoint               = optional(string, null)<br>        endpoint_auto_confirms = optional(bool, false)<br>      dead_letter_queue_arn = optional(string) })), [])<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Lambda name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
