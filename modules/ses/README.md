# ses

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
| [aws_iam_access_key.ses_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_group.ses_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.ses_user_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.ses_group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_user.ses_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.spf](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_ses_domain_dkim.ses_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.ses_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity.verified_domains](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_email_identity.verified_email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_email_identity) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ses_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_dkim_route53"></a> [create\_dkim\_route53](#input\_create\_dkim\_route53) | If DKIM records should be created in Route 53 | `bool` | `false` | no |
| <a name="input_create_spf_route53"></a> [create\_spf\_route53](#input\_create\_spf\_route53) | If TXT record for SPF should be created in Route 53 | `bool` | `false` | no |
| <a name="input_email_domain"></a> [email\_domain](#input\_email\_domain) | For which sender domain SES should be configured. | `string` | n/a | yes |
| <a name="input_mail_users"></a> [mail\_users](#input\_mail\_users) | User names for mail to create. | `list(string)` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for ses greoup be unique. | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where ressources should be managed. | `string` | `null` | no |
| <a name="input_verified_domains"></a> [verified\_domains](#input\_verified\_domains) | The domain name to assign to SES. | `list(string)` | `[]` | no |
| <a name="input_verified_email_users"></a> [verified\_email\_users](#input\_verified\_email\_users) | The emails address to assign to SES. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dkim_records"></a> [dkim\_records](#output\_dkim\_records) | DNS records for DKIM |
| <a name="output_secret_keys"></a> [secret\_keys](#output\_secret\_keys) | IAM Access Key ID and Secret |
| <a name="output_smtp_credentials"></a> [smtp\_credentials](#output\_smtp\_credentials) | SMTP Username and Passwort |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
