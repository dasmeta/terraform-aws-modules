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


```
# example 1 minimal options

module "create_user" {
    source                        = ""
    user-name                     = "test-user"
    create_user                   = true
    create_iam_user_login_profile = true
    create_iam_access_key         = true
    pgp_key                       = ""
    policy-arn                    = [
                                        "arn:aws:iam::aws:policy/ReadOnlyAccess", 
                                        "arn:aws:iam::aws:policy/IAMUserChangePassword"
                                    ]
    }

output "iam_user_name" {
  description = "The user's name"
  value       = module.create_user.iam_user_name
}

output "iam_user_arn" {
  description = "The ARN assigned by AWS for this user"
  value       = module.create_user.iam_user_arn
}

output "iam_access_key_id" {
  description = "The access key ID"
  value       = module.create_user.iam_access_key_id
}

output "keybase_password_decrypt_command" {
  description = "Decrypt user password command"
  value       = module.create_user.keybase_password_decrypt_command
}

output "keybase_secret_key_decrypt_command" {
  description = "Decrypt access secret key command"
  value       = module.create_user.keybase_secret_key_decrypt_command
}

# example 2 if you want to create policy

module "create_user" {
    source                        = ""
    user-name                     = "test-user"
    create_user                   = true
    create_iam_user_login_profile = true
    create_iam_access_key         = true
    pgp_key                       = ""
    policy-arn                    = [
                                        "arn:aws:iam::aws:policy/ReadOnlyAccess", 
                                        "arn:aws:iam::aws:policy/IAMUserChangePassword"
                                    ]
    create-new-policy             = false
    policy-name                   = "write-s3-backet"
    policy-resource               = "*"
    policy-action                 = [
                                        "s3:PutObject"
                                    ]
}
