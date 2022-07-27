## Example

```hcl
module "aws_iam_account_password_policy" {
  source        = "dasmeta/modules/aws//modules/am-account-password-policy"

  allow_users_to_change_password = true
  minimum_password_length        = 32
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  require_uppercase_characters   = true
  max_password_age               = 0
  hard_expiry                    = false
  password_reuse_prevention      = 0
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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_account_password_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_users_to_change_password"></a> [allow\_users\_to\_change\_password](#input\_allow\_users\_to\_change\_password) | Whether to allow users to change their own password. | `bool` | `false` | no |
| <a name="input_hard_expiry"></a> [hard\_expiry](#input\_hard\_expiry) | Whether users are prevented from setting a new password after their password has expired. | `bool` | `false` | no |
| <a name="input_max_password_age"></a> [max\_password\_age](#input\_max\_password\_age) | The number of days that an user password is valid. If specify 0, then passwords never expire. | `number` | `0` | no |
| <a name="input_minimum_password_length"></a> [minimum\_password\_length](#input\_minimum\_password\_length) | Minimum length to require for user passwords. | `number` | `8` | no |
| <a name="input_password_reuse_prevention"></a> [password\_reuse\_prevention](#input\_password\_reuse\_prevention) | The number of previous passwords that users are prevented from reusing. If specify 0, then allowed from reusing previous passwords. | `number` | `0` | no |
| <a name="input_require_lowercase_characters"></a> [require\_lowercase\_characters](#input\_require\_lowercase\_characters) | Whether to require lowercase characters for user passwords. | `bool` | `false` | no |
| <a name="input_require_numbers"></a> [require\_numbers](#input\_require\_numbers) | Whether to require numbers for user passwords. | `bool` | `false` | no |
| <a name="input_require_symbols"></a> [require\_symbols](#input\_require\_symbols) | Whether to require symbols for user passwords. | `bool` | `false` | no |
| <a name="input_require_uppercase_characters"></a> [require\_uppercase\_characters](#input\_require\_uppercase\_characters) | Whether to require uppercase characters for user passwords. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_account_password_policy_expire_passwords"></a> [iam\_account\_password\_policy\_expire\_passwords](#output\_iam\_account\_password\_policy\_expire\_passwords) | Indicates whether passwords in the account expire. |
<!-- END_TF_DOCS -->
