# basic

Creates a single CodeCommit repository named **`tf-test-codecommit`** for manual integration checks. The name is fixed: run **`terraform destroy`** before **`apply`** again in the same account, or change `repository_name` in `1-example.tf` if that name is already taken.

## Credentials (local)

Set a profile and region (adjust to your environment):

```bash
export AWS_PROFILE=payconomy-dev
export AWS_REGION=eu-central-1
aws sts get-caller-identity
```

Your IAM principal needs permission to create and delete CodeCommit repositories (for example `codecommit:*` on the test repo or broader admin in a dev account).

## Run

```bash
cd modules/codecommit/tests/basic
terraform init -upgrade
terraform validate
terraform apply
terraform destroy
```

Run **`terraform init -upgrade`** once if Terraform reports that the lock file pins AWS provider **6.x** while this folder and the parent module expect **`~> 5.0`**.

## Notes

- This test uses **local state** by default. Do **not** commit `terraform.tfstate` or `*.backup` to Git; remove them or rely on `.gitignore`.
- For module usage and inputs/outputs, see the [`../README.md`](../README.md) in the `codecommit` submodule.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | ../../ | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
