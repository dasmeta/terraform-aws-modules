### This module creates an AWS CodeCommit Git repository (`aws_codecommit_repository`) in the account and region of your AWS provider. The repository name must be unique in that account. The resource starts **empty**; push content with Git as usual. Use `default_branch` only when that branch **already exists** in the remote (after a first push).

## Example 1. Minimal parameter set

1. Apply module

```
module "test" {
  source = "dasmeta/modules/aws//modules/codecommit"

  repository_name = "my-repo"
}
```

## Example 2. Tags and description

```
module "test" {
  source = "dasmeta/modules/aws//modules/codecommit"

  repository_name = "my-repo"
  description     = "Application configuration"

  tags = {
    Environment = "dev"
    Team        = "platform"
  }
}
```

Outputs include `repository_arn`, `repository_name`, `clone_url_http`, and `clone_url_ssh` for wiring IAM, CI, or local Git.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
