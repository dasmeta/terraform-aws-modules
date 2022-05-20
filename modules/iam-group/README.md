
### Create AWS group and set ReadOnly permission.

## Example 1. Minimal parameter set and create read-only group

```
module "test-read-only" {
  source = "dasmeta/modules/aws//modules/iam-group"
  users  = []
}
```

## Example 2. Minimal parameter set and create admin-access group

```
module "test-admin-access" {
  source = "dasmeta/modules/aws//modules/iam-group"
  name   = "AdminUsers"
  type   = "admin-access"
  users  = ["test"]
}
```

## Example 3. Maxsimum parameter set and create permissions

```
module "test-own-access" {
  source = "dasmeta/modules/aws//modules/iam-group"
  name   = "OwnGroup"
  type   = "other"
  users  = ["test"]
  police_action = [ 
    "aws-portal:ViewBilling",
    "ec2:Describe*",
    ]
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
| [aws_iam_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"ReadOnlyGroup"` | no |
| <a name="input_policy_action"></a> [policy\_action](#input\_policy\_action) | n/a | `list(any)` | `[]` | no |
| <a name="input_type"></a> [type](#input\_type) | You can set read-only or admin-access or set other and set your own police action | `string` | `"read-only"` | no |
| <a name="input_users"></a> [users](#input\_users) | n/a | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->