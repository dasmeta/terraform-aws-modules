# basic

Creates a CodeCommit repository with a random name suffix so repeated applies in the same account do not hit a name conflict.

## Credentials (local)

Configure the AWS provider the same way as the CLI, for example:

```bash
export AWS_PROFILE=
export AWS_REGION=
aws sts get-caller-identity
```

## Run

```bash
cd modules/codecommit/tests/basic
terraform init 
terraform validate
terraform apply
terraform destroy
```

If your lock file was generated with AWS provider 6.x, run `terraform init -upgrade` once so it matches `~> 5.0` in this folder and in the parent module.
