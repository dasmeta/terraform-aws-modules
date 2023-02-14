# todo

- Terraform the creation of AWS ECR objects.

## Usage

**IMPORTANT:**
Repository names can have minimum 2 and maximum 256 characters. The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes.

# Case 1

```
module "ecr" {
     source  = "dasmeta/modules/aws//modules/ecr"
     repos = ["repo1"]
}
```

# Case 2

```
module "ecr" {
     source  = "dasmeta/modules/aws//modules/ecr"
     repos = ["repo1", "repo2", "repo3"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | cloudposse/ecr/aws | 0.35.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_max_image_count"></a> [max\_image\_count](#input\_max\_image\_count) | How many Docker Image versions AWS ECR will store. | `number` | `20` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | Name of image tags prefixes that should not be destroyed. Useful if you tag images with names like `dev`, `staging`, and `prod` | `set(string)` | `[]` | no |
| <a name="input_repos"></a> [repos](#input\_repos) | 0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_results"></a> [results](#output\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
