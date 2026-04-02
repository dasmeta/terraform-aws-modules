# basic

Creates a CodeCommit repository with a random name suffix and validates outputs using Terraform `check` blocks (requires Terraform >= 1.5).

## Credentials (local)

The AWS provider reads credentials the same way as the AWS CLI:

| Method | How |
|--------|-----|
| Profile | Files `~/.aws/credentials` and `~/.aws/config` — pass `-var="aws_profile=YOUR_PROFILE"` or set `export AWS_PROFILE=YOUR_PROFILE` (when `aws_profile` is null, `AWS_PROFILE` is still used by the SDK default chain). |
| Keys in env | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, optional `AWS_SESSION_TOKEN` |

Confirm the account Terraform will use:

```bash
aws sts get-caller-identity --profile YOUR_PROFILE   # if using a profile
# or without --profile if you rely on env vars / default profile
```

## Run

```bash
cd modules/codecommit/tests/basic
terraform init
terraform validate

# Example: fixed region + named profile
terraform apply -var="aws_profile=payconomy-dev" -var="aws_region=eu-central-1"

terraform destroy -var="aws_profile=payconomy-dev" -var="aws_region=eu-central-1"
```

Checks that depend on created resources run once outputs are known (after a successful apply).
