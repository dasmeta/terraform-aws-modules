# This is an module needed to apply each aws account region wide to set cloudwatch logs config
# if this not set it will fail to enable logs for api gateway
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
| [aws_api_gateway_account.account_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_cloudwatch_log_role"></a> [create\_cloudwatch\_log\_role](#input\_create\_cloudwatch\_log\_role) | This allows to create cloudwatch role which is one per aws account and is not region specific | `bool` | `false` | no |
| <a name="input_set_account_settings"></a> [set\_account\_settings](#input\_set\_account\_settings) | The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn, also cloudwatch role should be created before enabling setting | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
