
### Create AWS group and set ReadOnly permission.

## Example 1. Minimal parameter set and create permissions

```
module "test-read-only" {
  source = "dasmeta/modules/aws//modules/iam-read-only"
  attach_users_to_group = false
}
```

## Example 2. Maxsimum parameter set and create permissions

```
module "test-read-only" {
  source = "dasmeta/modules/aws//modules/iam-read-only"
  name   = "ReadOnlyTest"
  users  = ["test"]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.team](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.my_developer_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_users_to_group"></a> [attach\_users\_to\_group](#input\_attach\_users\_to\_group) | Attach Users in Group | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"ReadOnlyGroup"` | no |
| <a name="input_users"></a> [users](#input\_users) | n/a | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->