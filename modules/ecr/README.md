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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | git::https://github.com/dasmeta/terraform-aws-ecr.git | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_tag_mutability"></a> [image\_tag\_mutability](#input\_image\_tag\_mutability) | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE | `string` | `"MUTABLE"` | no |
| <a name="input_max_image_count"></a> [max\_image\_count](#input\_max\_image\_count) | How many Docker Image versions AWS ECR will store. | `number` | `20` | no |
| <a name="input_principals_readonly_access"></a> [principals\_readonly\_access](#input\_principals\_readonly\_access) | Principal ARNs to provide with readonly access to the ECR | `list(string)` | `[]` | no |
| <a name="input_protected_tags"></a> [protected\_tags](#input\_protected\_tags) | Image tags patterns (prefixes and wildcards) that should not be destroyed. If item contains asterisk symbol('*') it considered as wildcard, overwise as prefix matching | `set(string)` | <pre>[<br/>  "latest",<br/>  "image-keep",<br/>  "*prod*",<br/>  "*.*.*"<br/>]</pre> | no |
| <a name="input_repos"></a> [repos](#input\_repos) | 0 out of 256 characters maximum (2 minimum). The name must start with a letter and can only contain lowercase letters, numbers, hyphens, underscores, and forward slashes. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_results"></a> [results](#output\_results) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
