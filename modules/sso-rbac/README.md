<!-- BEGIN_TF_DOCS -->
# Example Setup

```terraform

module "sso-deploy" {
  source = "../sso-deploy"

  permission_sets = [
    {
      name               = "development",
      description        = "Give a user full admininstrator access to an account",
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      relay_state        = "",
      session_duration   = "",
      inline_policy      = "",
      tags               = {}
    },
    {
      name               = "accounting",
      description        = "Give a user full admininstrator access to an account",
      policy_attachments = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      relay_state        = "",
      session_duration   = "",
      inline_policy      = "",
      tags               = {}
    }
  ]

  account_assignments = [
    {
      account = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["development"],
      permission_set_arn = module.sso-deploy.permission_set_arn["development"],
      principal_type = "GROUP",
      principal_name = "development"
    },
    {
      account = "471767607298",
      permission_set_name = module.sso-deploy.permission_set_name["accounting"],
      permission_set_arn = module.sso-deploy.permission_set_arn["accounting"],
      principal_type = "GROUP",
      principal_name = "accounting"
    }
    ]

  cluster_name   = "my-cluster"
  cluster_region = "eu-west-1"
  group_arn  = "arn:aws:iam::471767607298:role/AWSReservedSSO_development_6d8ab1c0b48350e7"
  rbac_group = "dev-group"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_managed_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_managed_policy_attachment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_permission_set_inline_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set_inline_policy) | resource |
| [kubernetes_role_binding.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_v1.k8s-rbac](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1) | resource |
| [null_resource.provision1](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.provision2](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_group) | data source |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/identitystore_user) | data source |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_assignments"></a> [account\_assignments](#input\_account\_assignments) | n/a | <pre>list(object({<br>    account             = string<br>    permission_set_name = string<br>    permission_set_arn  = string<br>    principal_name      = string<br>    principal_type      = string<br>  }))</pre> | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | n/a | yes |
| <a name="input_cluster_region"></a> [cluster\_region](#input\_cluster\_region) | n/a | `string` | n/a | yes |
| <a name="input_group_arn"></a> [group\_arn](#input\_group\_arn) | n/a | `string` | n/a | yes |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | n/a | <pre>list(object({<br>    name               = string<br>    description        = string<br>    relay_state        = string<br>    session_duration   = string<br>    tags               = map(string)<br>    inline_policy      = string<br>    policy_attachments = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_rbac_group"></a> [rbac\_group](#input\_rbac\_group) | n/a | `string` | n/a | yes |
| <a name="input_rbac_role_binding"></a> [rbac\_role\_binding](#input\_rbac\_role\_binding) | n/a | <pre>list(object({<br>    rolebinding_name = string<br>    role_name        = string<br>    namespace        = string<br>    principal_kind   = string<br>    role_kind        = string<br>    group_name       = string<br>    api_groups       = string<br>  }))</pre> | n/a | yes |
| <a name="input_rbac_rule"></a> [rbac\_rule](#input\_rbac\_rule) | n/a | <pre>list(object({<br>    name           = string<br>    namespace      = string<br>    api_groups     = list(string)<br>    resources      = list(string)<br>    resource_names = list(string)<br>    verbs          = list(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_permission_set_arn"></a> [permission\_set\_arn](#output\_permission\_set\_arn) | n/a |
| <a name="output_permission_set_name"></a> [permission\_set\_name](#output\_permission\_set\_name) | n/a |
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | n/a |
<!-- END_TF_DOCS -->
