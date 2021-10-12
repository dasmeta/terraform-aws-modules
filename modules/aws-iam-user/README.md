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

module "modules_aws-secret" {
  source  = "dasmeta/modules/aws//modules/aws-secret"
  version = "0.9.3"
  # insert the 2 required variables here
}

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
