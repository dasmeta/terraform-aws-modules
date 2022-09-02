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

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | cloudposse/ecr/aws | 0.32.2 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repos"></a> [repos](#input\_repos) | 0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes. | `list(any)` | <pre>[<br>  "repo1",<br>  "repo2",<br>  "repo3"<br>]</pre> | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
