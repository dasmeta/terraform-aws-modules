# Minimum usage example

This module creates an "example-pool" and a "main" client. Both of them have default values a part of which is described in the variables.tf file.

```
module "cognito" {
  source = "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

  name = "example-pool"
  clients = ["main"]
  auto_verified_attributes = [ "email" ]
}
```


# Usage example

In this example sms and email verification or authentication messages are added. They are properly described in the variables.tf file.

```
module "user-pool" {
    source =  "git::https://github.com/dasmeta/terraform.git//modules/cognito?ref=0.5.0"

    name = "example2-pool"
    clients = ["main-client"]
    email_verification_message = "Email verification message: {####}"
    email_verification_subject = "Your verification code"
    sms_authentication_message = "SMS example: {####}"
    sms_verification_message   = "SMS example: {####}"

    verification_message_template = {
        email_message_by_link = "Please click the link below to verify your email address. {##Verify Email##} "
        email_subject_by_link = "Your verification link"
    }
}
```

# Another usage example

Here schemas, lambda_config and sms_configuration are added. Also if you want to generate secrets for app clients, generate_secret have to be set true.

```
module "cognito" {
    source = "../../terraform-aws-modules/modules/cognito-user-pool"  

    name                       = "example3-pool"
    email_verification_message = "Your verification code is {####}. "
    email_verification_subject = "Your verification code"
    sms_authentication_message = "Your verification code is {####}. "
    sms_verification_message   = "Your verification code is {####}. "
    clients = ["client1", "client2"]
    generate_secret = true
    schema = [
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "email"
        required                 = true

        string_attribute_constraints = {
            max_length = "2048"
            min_length = "0"
        }
      },
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "location"
        required                 = false

        string_attribute_constraints = {
            max_length = "256"
            min_length = "1"
        }
      },
      {
        attribute_data_type      = "String"
        developer_only_attribute = false
        mutable                  = true
        name                     = "phone_number"
        required                 = true

        string_attribute_constraints = {
            max_length = "2048"
            min_length = "0"
        }
     }
    ]

    lambda_config = {
      kms_key_id = "arn:aws:kms:eu-central-1..."
      custom_email_sender = {
          lambda_arn     = "arn:aws:lambda:eu-central-1:..."
          lambda_version = "V1_0"
      }
    }

    sms_configuration = {
      external_id    = "some id"
      sns_caller_arn = "arn:aws:iam::..."
    }
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
| [aws_cognito_user_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_route53_record.auth-cognito-A](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token_validity"></a> [access\_token\_validity](#input\_access\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in token\_validity\_units. | `number` | `120` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes supported as an alias for this user pool. | `list(string)` | <pre>[<br>  "email",<br>  "phone_number"<br>]</pre> | no |
| <a name="input_allowed_oauth_flows"></a> [allowed\_oauth\_flows](#input\_allowed\_oauth\_flows) | List of allowed OAuth flows (code, implicit, client\_credentials). | `list(string)` | `[]` | no |
| <a name="input_allowed_oauth_flows_user_pool_client"></a> [allowed\_oauth\_flows\_user\_pool\_client](#input\_allowed\_oauth\_flows\_user\_pool\_client) | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools. | `bool` | `false` | no |
| <a name="input_allowed_oauth_scopes"></a> [allowed\_oauth\_scopes](#input\_allowed\_oauth\_scopes) | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin). | `list(string)` | `[]` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | Attributes to be auto-verified. | `list(string)` | <pre>[<br>  "email",<br>  "phone_number"<br>]</pre> | no |
| <a name="input_callback_urls"></a> [callback\_urls](#input\_callback\_urls) | List of allowed callback URLs for the identity providers. | `list(string)` | `[]` | no |
| <a name="input_case_sensitive"></a> [case\_sensitive](#input\_case\_sensitive) | Whether username case sensitivity will be applied for all users in the user pool through Cognito APIs. | `bool` | `null` | no |
| <a name="input_cert_arn"></a> [cert\_arn](#input\_cert\_arn) | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain. | `string` | `""` | no |
| <a name="input_challenge_required_on_new_device"></a> [challenge\_required\_on\_new\_device](#input\_challenge\_required\_on\_new\_device) | Whether a challenge is required on a new device. Only applicable to a new device. | `bool` | `null` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | List of client names | `list(string)` | `[]` | no |
| <a name="input_create_route53_record"></a> [create\_route53\_record](#input\_create\_route53\_record) | Create Route53 Record | `bool` | `true` | no |
| <a name="input_device_only_remembered_on_user_prompt"></a> [device\_only\_remembered\_on\_user\_prompt](#input\_device\_only\_remembered\_on\_user\_prompt) | Whether a device is only remembered on user prompt. | `bool` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain string. | `string` | `""` | no |
| <a name="input_email_verification_message"></a> [email\_verification\_message](#input\_email\_verification\_message) | String representing the email verification message. | `string` | `"Some message {####}"` | no |
| <a name="input_email_verification_subject"></a> [email\_verification\_subject](#input\_email\_verification\_subject) | String representing the email verification subject. | `string` | `"Some subject"` | no |
| <a name="input_enable_token_revocation"></a> [enable\_token\_revocation](#input\_enable\_token\_revocation) | Enables or disables token revocation. | `bool` | `true` | no |
| <a name="input_explicit_auth_flows"></a> [explicit\_auth\_flows](#input\_explicit\_auth\_flows) | List of authentication flows. | `list(string)` | <pre>[<br>  "ALLOW_REFRESH_TOKEN_AUTH",<br>  "ALLOW_USER_PASSWORD_AUTH",<br>  "ALLOW_USER_SRP_AUTH"<br>]</pre> | no |
| <a name="input_generate_secret"></a> [generate\_secret](#input\_generate\_secret) | Should an application secret be generated. | `bool` | `false` | no |
| <a name="input_id_token_validity"></a> [id\_token\_validity](#input\_id\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. This value will be overridden if you have entered a value in token\_validity\_units. | `number` | `120` | no |
| <a name="input_invite_message_template"></a> [invite\_message\_template](#input\_invite\_message\_template) | email\_message is a message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively. email\_subject is a subject line for email messages. sms\_message is a message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively. | `map` | <pre>{<br>  "email_message": "Your username is {username} and temporary password is {####}. ",<br>  "email_subject": "Your temporary password",<br>  "sms_message": "Your username is {username} and temporary password is {####}. "<br>}</pre> | no |
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | n/a | `map` | <pre>{<br>  "custom_email_sender": {<br>    "lambda_arn": "",<br>    "lambda_version": ""<br>  },<br>  "kms_key_id": ""<br>}</pre> | no |
| <a name="input_logout_urls"></a> [logout\_urls](#input\_logout\_urls) | List of allowed logout URLs for the identity providers. | `list(string)` | `[]` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Multi-Factor Authentication (MFA) configuration for the User Pool. | `string` | `"OPTIONAL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the pool that will be created | `string` | `"Pool name"` | no |
| <a name="input_precedence"></a> [precedence](#input\_precedence) | The precedence of the user group. | `number` | `0` | no |
| <a name="input_prevent_user_existence_errors"></a> [prevent\_user\_existence\_errors](#input\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. | `string` | `"LEGACY"` | no |
| <a name="input_read_attributes"></a> [read\_attributes](#input\_read\_attributes) | List of user pool attributes the application client can read from. | `list(string)` | <pre>[<br>  "address",<br>  "birthdate",<br>  "email",<br>  "email_verified",<br>  "family_name",<br>  "gender",<br>  "given_name",<br>  "locale",<br>  "middle_name",<br>  "name",<br>  "nickname",<br>  "phone_number",<br>  "phone_number_verified",<br>  "picture",<br>  "preferred_username",<br>  "profile",<br>  "updated_at",<br>  "website",<br>  "zoneinfo"<br>]</pre> | no |
| <a name="input_recovery_mechanism"></a> [recovery\_mechanism](#input\_recovery\_mechanism) | Name is the recovery method for a user. Priority is a positive integer specifying priority of a method with 1 being the highest priority. | `list` | <pre>[<br>  {<br>    "name": "verified_email",<br>    "priority": 2<br>  },<br>  {<br>    "name": "verified_phone_number",<br>    "priority": 1<br>  }<br>]</pre> | no |
| <a name="input_refresh_token_validity"></a> [refresh\_token\_validity](#input\_refresh\_token\_validity) | Time limit in days refresh tokens are valid for. | `number` | `7` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role to be associated with the user group. | `string` | `""` | no |
| <a name="input_schema"></a> [schema](#input\_schema) | n/a | `list` | <pre>[<br>  {<br>    "attribute_data_type": "String",<br>    "developer_only_attribute": false,<br>    "mutable": true,<br>    "name": "email",<br>    "required": true,<br>    "string_attribute_constraints": {<br>      "max_length": "",<br>      "min_length": ""<br>    }<br>  }<br>]</pre> | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | String representing the SMS authentication message. The Message must contain the {####} placeholder, which will be replaced with the code. | `string` | `"SMS authentication message {####}"` | no |
| <a name="input_sms_configuration"></a> [sms\_configuration](#input\_sms\_configuration) | external\_id is external ID used in IAM role trust relationships. sns\_caller\_arn is ARN of the Amazon SNS caller. | `map(any)` | <pre>{<br>  "external_id": "",<br>  "sns_caller_arn": ""<br>}</pre> | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | String representing the SMS verification message. | `string` | `"SMS verification message {####}"` | no |
| <a name="input_software_token_mfa_configuration"></a> [software\_token\_mfa\_configuration](#input\_software\_token\_mfa\_configuration) | Whether to enable software token Multi-Factor (MFA) tokens, such as Time-based One-Time Password (TOTP). | `bool` | `true` | no |
| <a name="input_supported_identity_providers"></a> [supported\_identity\_providers](#input\_supported\_identity\_providers) | List of provider names for the identity providers that are supported on this client. | `list(string)` | `[]` | no |
| <a name="input_token_validity_units"></a> [token\_validity\_units](#input\_token\_validity\_units) | access\_token is time unit in for the value in access\_token\_validity. id\_token is time unit in for the value in id\_token\_validity. refresh\_token is time unit in for the value in refresh\_token\_validity. | `map(any)` | <pre>{<br>  "access_token": "minutes",<br>  "id_token": "minutes",<br>  "refresh_token": "days"<br>}</pre> | no |
| <a name="input_user_group"></a> [user\_group](#input\_user\_group) | The name of the user group. | `string` | `""` | no |
| <a name="input_verification_message_template"></a> [verification\_message\_template](#input\_verification\_message\_template) | email\_message\_by\_link is an email message template for sending a confirmation link to the user, it must contain the {##Click Here##} placeholder. email\_subject\_by\_link is an email message template for sending a confirmation link to the user, it must contain the {##Click Here##} placeholder. | `map(any)` | <pre>{<br>  "email_message_by_link": "Please click the link below to verify your email address. {##Verify Email##} ",<br>  "email_subject_by_link": "Your verification link. {##Verify Email##}"<br>}</pre> | no |
| <a name="input_write_attributes"></a> [write\_attributes](#input\_write\_attributes) | List of user pool attributes the application client can write to. | `list(string)` | <pre>[<br>  "address",<br>  "birthdate",<br>  "email",<br>  "family_name",<br>  "gender",<br>  "given_name",<br>  "locale",<br>  "middle_name",<br>  "name",<br>  "nickname",<br>  "phone_number",<br>  "picture",<br>  "preferred_username",<br>  "profile",<br>  "updated_at",<br>  "website",<br>  "zoneinfo"<br>]</pre> | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | R53 zone. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | AWS Cognito User Pool ARN |
| <a name="output_clients_id"></a> [clients\_id](#output\_clients\_id) | n/a |
<!-- END_TF_DOCS -->
