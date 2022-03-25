# iam-user

Creates IAM user, IAM login profile, IAM access key and uploads IAM SSH user public key. All of these are optional resources.

## Notes for keybase users

**If possible, always use PGP encryption to prevent Terraform from keeping unencrypted password and access secret key in state file.**

### Keybase pre-requisits

When `pgp_key` is specified as `keybase:username`, make sure that that user has already uploaded public key to keybase.io. For example, user with username `test` has done it properly and you can [verify it here](https://keybase.io/test/pgp_keys.asc).

### How to decrypt user's encrypted password and secret key

This module outputs commands and PGP messages which can be decrypted either using [keybase.io web-site](https://keybase.io/decrypt) or using command line to get user's password and user's secret key:
- `keybase_password_decrypt_command`
- `keybase_secret_key_decrypt_command`
- `keybase_password_pgp_message`
- `keybase_secret_key_pgp_message`

# Use Cases

## Case 1

case 1 creates an AWS IAM user with Programmatic access , AWS Management Console access and policy attachment to the user. 
  - Programmatic access: Used the AWS CLI, or use the Tools for Windows PowerShell.

  - AWS Management Console access: Used the for AWS Management Console

At the `terraform apply` shows the parameters of the user ( User  Name, User ARN, AWS Access Key, AWS Management Console Password, AWS Secret Key)

```terraform

module "aws-read-only" {
    source                  = "dasmeta/modules/aws//modules/aws-iam-user"
    username                = "test-user"
    pgp_key                 = "keybase:devopsmher"
    policy_attachment       = [
                                  "arn:aws:iam::aws:policy/ReadOnlyAccess", 
                                  "arn:aws:iam::aws:policy/IAMUserChangePassword"
                              ]
}

output "iam_user_name" {
  description = "The user's name"
  value       = module.aws-read-only.iam_user_name
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.aws-read-only.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.aws-read-only.iam_user_arn
}

output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = module.aws-read-only.keybase_password_decrypt_command
}

output "keybase_secret_key_decrypt_command" {
  description = "Decrypt access secret key command"
  value       = module.aws-read-only.keybase_secret_key_decrypt_command
}
```

## Case 2

case 2 creates an AWS IAM user with Programmatic access after create new policy and policy attachment to the user. 
  - Programmatic access: Used the AWS CLI, or use the Tools for Windows PowerShell.

At the `terraform apply` shows the parameters of the user ( User  Name, User ARN, AWS Access Key, AWS Secret Key)


```terraform
module "mongodb-backup-s3-storage-user" {
  source          = "dasmeta/modules/aws//modules/aws-iam-user"
  username        = "mongodb-backup-s3-storage-user"
  console         = false
  policy          = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::s3-backet-mongo-backup" # arn resource 
        }
    ]
})
}

output "iam_user_name" {
  description = "The user's name"
  value       = module.mongodb-backup-s3-storage-user.iam_user_name
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.mongodb-backup-s3-storage-user.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.mongodb-backup-s3-storage-user.iam_user_arn
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = nonsensitive(module.mongodb-backup-s3-storage-user.iam_access_key_secret)
  sensitive   = false
}

```
## Case 3

case 3 creates an AWS IAM user with Programmatic access. 
 - Programmatic access: Used the AWS CLI, or use the Tools for Windows PowerShell.
 
At the `terraform apply` shows the parameters of the user ( User  Name, User ARN, AWS Access Key, AWS Secret Key)


```terraform

module "mongodb-backup-s3-storage-user" {
  source              = "dasmeta/modules/aws//modules/aws-iam-user"
  username            = "mongodb-backup-s3-storage-user"
  console             = false
}

output "iam_user_name" {
  description = "The user's name"
  value       = module.mongodb-backup-s3-storage-user.iam_user_name
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.mongodb-backup-s3-storage-user.iam_access_key_id
}
output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.mongodb-backup-s3-storage-user.iam_user_arn
}

output "iam_access_key_secret" {
  description = "The access key secret"
  value       = nonsensitive(module.mongodb-backup-s3-storage-user.iam_access_key_secret)
  sensitive   = false
}

```

## Case 4

case 2 creates an AWS IAM user with  AWS Management Console access.
  - AWS Management Console access: Used the for AWS Management Console

At the `terraform apply` shows the parameters of the user ( User  Name, User ARN, AWS Management Console Password)

```terraform

module "mongodb-backup-s3-storage-user" {
  source              = "dasmeta/modules/aws//modules/aws-iam-user"
  username            = "mongodb-backup-s3-storage-user"
  pgp_key             = "keybase:devopsmher"
  api                 = false
}

output "iam_user_name" {
  description = "The user's name"
  value       = module.mongodb-backup-s3-storage-user.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.mongodb-backup-s3-storage-user.iam_user_arn
}

output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = module.mongodb-backup-s3-storage-user.keybase_password_decrypt_command
}
```
## Case 5 with local pgp_key

### How to Use PGP to Encrypt Your Terraform Secrets


### - Step 1 : make sure gpg is installed

```bash

gpg --version

```

### - Step 2 : Creating Your Encryption Key

```bash

echo "%echo Generating a basic OpenPGP key \n Key-Type: RSA \n Key-Length: 2048 \n Subkey-Type: RSA\n Subkey-Curve: nistp256\n Subkey-Length: 2048\n Name-Real: Das Meta\n Name-Comment: How to Use PGP to Encrypt Your Terraform Secrets\n Name-Email: devops@dasmeta.com\n Expire-Date: 0\n Passphrase: Hgv1231vv23j1hv23\n # Do a commit here, so that we can later print "done" :-)\n %commit\n %echo done" >  key-gen-template && gpg --gen-key --batch key-gen-template && gpg --export "devops@dasmeta.com" | base64

```
-  Passphrase: `Hgv1231vv23j1hv23`
- Copy the result key and insert it in the module as the `pgp_key` in step 3.


### - Step 3 : creates an AWS IAM user with Programmatic access with local `pgp_key`

AWS Management Console access and policy attachment to the user. 
  - Programmatic access: Used the AWS CLI, or use the Tools for Windows PowerShell.

  - AWS Management Console access: Used the for AWS Management Console

At the `terraform apply` shows the ouputs which we will use in step 4(for example user password or access_key) of the user ( User ARN, AWS Access Key, AWS Management Console Password, AWS Secret Key)

```terraform

module "aws-read-only" {
    source                  = "dasmeta/modules/aws//modules/aws-iam-user"
    username                = "test-user"
    pgp_key                 = "your-pgp-key"
    policy_attachment       = [
                                  "arn:aws:iam::aws:policy/ReadOnlyAccess", 
                                  "arn:aws:iam::aws:policy/IAMUserChangePassword"
                              ]
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.aws-read-only.iam_access_key_id
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.aws-read-only.iam_user_arn
}

output "iam_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = module.aws-read-only.iam_access_key_encrypted_secret =="" ? null : <<EOF
export GPG_TTY=$(tty) && echo "${module.aws-read-only.iam_user_login_profile_encrypted_password}" | base64 --decode | gpg --decrypt
EOF
}
output "secret_access_key" {
  description = "The encrypted secret, base64 encoded"
  value       = module.aws-read-only.iam_access_key_encrypted_secret =="" ? null : <<EOF
export GPG_TTY=$(tty) && echo "${module.aws-read-only.iam_access_key_encrypted_secret}" | base64 --decode | gpg --decrypt
EOF
}

```

### Step 4 : Decode each encoded data from step 3 outputs
after successfull Step 3 there should be shell/console commands as output for the following ouputs `iam_user_login_profile_encrypted_password` and `secret_access_key` .

You have to copy the `{COMMAND}` and run in shell/console. Here is the form of output: 

```bash
Outputs:

iam_access_key_id = "XXXXXXXXXXXXXXXXXXXXX"
iam_user_arn = "arn:aws:iam::::"
iam_user_login_profile_encrypted_password = <<EOT

{COMMAND}

EOT
secret_access_key = <<EOT

{COMMAND}

EOT

```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_user"></a> [iam\_user](#module\_iam\_user) | terraform-aws-modules/iam/aws//modules/iam-user | 4.6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_user_policy.iam_user_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy_attachment.user-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api"></a> [api](#input\_api) | Whether to create IAM access key | `bool` | `true` | no |
| <a name="input_console"></a> [console](#input\_console) | Whether to create IAM user login profile | `bool` | `true` | no |
| <a name="input_create-new-policy"></a> [create-new-policy](#input\_create-new-policy) | If value true will create new policy | `bool` | `false` | no |
| <a name="input_create_user"></a> [create\_user](#input\_create\_user) | Whether to create the IAM user | `bool` | `true` | no |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true` | `string` | `""` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | IAM policy resource | `any` | `null` | no |
| <a name="input_policy_attachment"></a> [policy\_attachment](#input\_policy\_attachment) | IAM user name | `list(string)` | `[]` | no |
| <a name="input_username"></a> [username](#input\_username) | Desired name for the IAM user | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_access_key_encrypted_secret"></a> [iam\_access\_key\_encrypted\_secret](#output\_iam\_access\_key\_encrypted\_secret) | The encrypted secret, base64 encoded |
| <a name="output_iam_access_key_id"></a> [iam\_access\_key\_id](#output\_iam\_access\_key\_id) | The access key ID |
| <a name="output_iam_access_key_key_fingerprint"></a> [iam\_access\_key\_key\_fingerprint](#output\_iam\_access\_key\_key\_fingerprint) | The fingerprint of the PGP key used to encrypt the secret |
| <a name="output_iam_access_key_secret"></a> [iam\_access\_key\_secret](#output\_iam\_access\_key\_secret) | The access key secret |
| <a name="output_iam_access_key_ses_smtp_password_v4"></a> [iam\_access\_key\_ses\_smtp\_password\_v4](#output\_iam\_access\_key\_ses\_smtp\_password\_v4) | The secret access key converted into an SES SMTP password |
| <a name="output_iam_access_key_status"></a> [iam\_access\_key\_status](#output\_iam\_access\_key\_status) | Active or Inactive. Keys are initially active, but can be made inactive by other means. |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | The ARN assigned by AWS for this user |
| <a name="output_iam_user_login_profile_encrypted_password"></a> [iam\_user\_login\_profile\_encrypted\_password](#output\_iam\_user\_login\_profile\_encrypted\_password) | The encrypted password, base64 encoded |
| <a name="output_iam_user_login_profile_key_fingerprint"></a> [iam\_user\_login\_profile\_key\_fingerprint](#output\_iam\_user\_login\_profile\_key\_fingerprint) | The fingerprint of the PGP key used to encrypt the password |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | The user's name |
| <a name="output_iam_user_unique_id"></a> [iam\_user\_unique\_id](#output\_iam\_user\_unique\_id) | The unique ID assigned by AWS |
| <a name="output_keybase_password_decrypt_command"></a> [keybase\_password\_decrypt\_command](#output\_keybase\_password\_decrypt\_command) | Decrypt user password command |
| <a name="output_keybase_password_pgp_message"></a> [keybase\_password\_pgp\_message](#output\_keybase\_password\_pgp\_message) | Encrypted password |
| <a name="output_keybase_secret_key_decrypt_command"></a> [keybase\_secret\_key\_decrypt\_command](#output\_keybase\_secret\_key\_decrypt\_command) | Decrypt access secret key command |
| <a name="output_keybase_secret_key_pgp_message"></a> [keybase\_secret\_key\_pgp\_message](#output\_keybase\_secret\_key\_pgp\_message) | Encrypted access secret key |
| <a name="output_pgp_key"></a> [pgp\_key](#output\_pgp\_key) | PGP key used to encrypt sensitive data for this user (if empty - secrets are not encrypted) |
<!-- END_TF_DOCS -->