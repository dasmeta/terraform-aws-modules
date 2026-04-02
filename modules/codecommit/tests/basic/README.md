# basic

Creates a single CodeCommit repository named **`tf-test-codecommit`** for manual integration checks. The name is fixed: destroy before switching AWS accounts, or change the name if it already exists where you run the test.

## Credentials (local)

```bash
export AWS_PROFILE=
export AWS_REGION=
aws sts get-caller-identity
```

## Run

```bash
cd modules/codecommit/tests/basic
terraform init -upgrade
terraform validate
terraform apply
terraform destroy
```

Use `terraform init -upgrade` if the lock file still pins AWS provider 6.x but this folder requires `~> 5.0`.
