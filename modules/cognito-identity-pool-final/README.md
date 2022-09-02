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
| [aws_cognito_identity_pool.identity-pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool) | resource |
| [aws_cognito_identity_pool_roles_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment) | resource |
| [aws_cognito_user_pool.user-pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_iam_role.authenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.authenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_classic_flow"></a> [allow\_classic\_flow](#input\_allow\_classic\_flow) | Enables or disables the classic / basic authentication flow. | `bool` | `false` | no |
| <a name="input_allow_unauthenticated_identities"></a> [allow\_unauthenticated\_identities](#input\_allow\_unauthenticated\_identities) | Whether the identity pool supports unauthenticated logins or not. | `bool` | `false` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | The Cognito Identity Pool name. | `string` | `"my-identity-pool"` | no |
| <a name="input_user_pool_client"></a> [user\_pool\_client](#input\_user\_pool\_client) | A user pool client name. | `string` | `"user1"` | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | Name of the user pool that will be created. | `string` | `"my-user-pool"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
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
| [aws_cognito_identity_pool.identity-pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool) | resource |
| [aws_cognito_identity_pool_roles_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment) | resource |
| [aws_cognito_user_pool.user-pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_iam_role.authenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.authenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_classic_flow"></a> [allow\_classic\_flow](#input\_allow\_classic\_flow) | Enables or disables the classic / basic authentication flow. | `bool` | `false` | no |
| <a name="input_allow_unauthenticated_identities"></a> [allow\_unauthenticated\_identities](#input\_allow\_unauthenticated\_identities) | Whether the identity pool supports unauthenticated logins or not. | `bool` | `false` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | The Cognito Identity Pool name. | `string` | `"my-identity-pool"` | no |
| <a name="input_user_pool_client"></a> [user\_pool\_client](#input\_user\_pool\_client) | A user pool client name. | `string` | `"user1"` | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | Name of the user pool that will be created. | `string` | `"my-user-pool"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
