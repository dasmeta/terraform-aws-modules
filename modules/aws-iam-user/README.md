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

case 5 creates an AWS IAM user with Programmatic access with local pgp_key, AWS Management Console access and policy attachment to the user. 
  - Programmatic access: Used the AWS CLI, or use the Tools for Windows PowerShell.

  - AWS Management Console access: Used the for AWS Management Console

At the `terraform apply` shows the parameters of the user ( User ARN, AWS Access Key, AWS Management Console Password, AWS Secret Key)

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