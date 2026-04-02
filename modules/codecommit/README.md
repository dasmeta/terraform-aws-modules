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

A small **manual integration test** lives under [`tests/basic`](tests/basic): it applies this module with a fixed repository name against your AWS credentials (optional for consumers; useful when developing the module).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_codecommit_repository.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | Default branch name; the branch must already exist in the repository (for example after an initial push). | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the repository. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN of the KMS key used to encrypt and decrypt repository contents; omit to use the default AWS managed key. | `string` | `null` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Name of the repository. Must be unique within the AWS account. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of tags to assign to the repository. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_clone_url_http"></a> [clone\_url\_http](#output\_clone\_url\_http) | HTTP URL to clone the repository for IAM or root users. |
| <a name="output_clone_url_ssh"></a> [clone\_url\_ssh](#output\_clone\_url\_ssh) | SSH URL to clone the repository for IAM users configuring SSH public keys. |
| <a name="output_repository_arn"></a> [repository\_arn](#output\_repository\_arn) | ARN of the CodeCommit repository. |
| <a name="output_repository_id"></a> [repository\_id](#output\_repository\_id) | ID of the CodeCommit repository. |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | Name of the CodeCommit repository. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
