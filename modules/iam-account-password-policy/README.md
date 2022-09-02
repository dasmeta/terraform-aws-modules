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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_iam_account_password_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |

## Inputs

| Name                                                                                                                        | Description                                                                                                                         | Type     | Default | Required |
| --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_allow_users_to_change_password"></a> [allow_users_to_change_password](#input_allow_users_to_change_password) | Whether to allow users to change their own password.                                                                                | `bool`   | `false` |    no    |
| <a name="input_hard_expiry"></a> [hard_expiry](#input_hard_expiry)                                                          | Whether users are prevented from setting a new password after their password has expired.                                           | `bool`   | `false` |    no    |
| <a name="input_max_password_age"></a> [max_password_age](#input_max_password_age)                                           | The number of days that an user password is valid. If specify 0, then passwords never expire.                                       | `number` | `0`     |    no    |
| <a name="input_minimum_password_length"></a> [minimum_password_length](#input_minimum_password_length)                      | Minimum length to require for user passwords.                                                                                       | `number` | `8`     |    no    |
| <a name="input_password_reuse_prevention"></a> [password_reuse_prevention](#input_password_reuse_prevention)                | The number of previous passwords that users are prevented from reusing. If specify 0, then allowed from reusing previous passwords. | `number` | `0`     |    no    |
| <a name="input_require_lowercase_characters"></a> [require_lowercase_characters](#input_require_lowercase_characters)       | Whether to require lowercase characters for user passwords.                                                                         | `bool`   | `false` |    no    |
| <a name="input_require_numbers"></a> [require_numbers](#input_require_numbers)                                              | Whether to require numbers for user passwords.                                                                                      | `bool`   | `false` |    no    |
| <a name="input_require_symbols"></a> [require_symbols](#input_require_symbols)                                              | Whether to require symbols for user passwords.                                                                                      | `bool`   | `false` |    no    |
| <a name="input_require_uppercase_characters"></a> [require_uppercase_characters](#input_require_uppercase_characters)       | Whether to require uppercase characters for user passwords.                                                                         | `bool`   | `false` |    no    |

## Outputs

| Name                                                                                                                                                                    | Description                                        |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| <a name="output_iam_account_password_policy_expire_passwords"></a> [iam_account_password_policy_expire_passwords](#output_iam_account_password_policy_expire_passwords) | Indicates whether passwords in the account expire. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
