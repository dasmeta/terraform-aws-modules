# cloudfront_functions

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_code"></a> [code](#input\_code) | Function code | `any` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | Function comment | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Function name | `string` | n/a | yes |
| <a name="input_publish"></a> [publish](#input\_publish) | Function Publish | `bool` | `true` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Function runtime | `string` | `"cloudfront-js-1.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
