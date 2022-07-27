
### If you want  have high level security in your eks cluster. You can use this module and setup users permission in one namespace. Users can deploy resources only one namespaces in eks and don't change serviceaccount.

## Example 1. Minimal parameter set and create permissions

1. Apply module

```
module "test" {
  source = "dasmeta/modules/aws//modules/eks-iam-user"

  name      = "test"
  namespace = "test"

  usernames      = ["test"]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

output "role_arn" {
  value = module.test
}

output "module_output" {
  value = module.test
}
```

2. After apply module you should change aws-auth configmap if you use eks module you can change map_role variable.

```
kubectl get configmap/aws-auth -nkube-system
```

```
  map_roles = [{
    rolearn  = "arn:aws:iam::5***168:role/test"  # Module output role arn
    username = "test" # Role name
    groups   = ["test-namespace"] # Module output group name
  }]
```

3. Update eks config and check

```
aws eks update-kubeconfig --name <cluster-name> --role-arn <role-arn>
```

## Example 2. Maximal  parameter set and create permissions
```
module "test" {
  source = "dasmeta/modules/aws//modules/eks-iam-user"

  name      = "test"
  namespace = "test"
  create_namespace = true
  rule = [
    {
      api_groups = ["", "apps"]
      resources  = ["pods", "pods/log", "configmaps", "services", "endpoints", "crontabs", "deployments", "nodes"]
      verbs      = ["*"]
    },
    {
      api_groups = ["extensions"]
      resources  = ["pods", "pods/log", "configmaps", "services", "endpoints", "crontabs", "deployments", "nodes"]
      verbs      = ["*"]
    }
  ]

  usernames      = ["test"]
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

output "module_output" {
  value = module.test
}

```

2. After apply module you should change aws-auth configmap if you use eks module you can change map_role variable.

```
kubectl get configmap/aws-auth -nkube-system
```

```
  map_roles = [{
    rolearn  = "arn:aws:iam::5***168:role/test"  # Module output role arn
    username = "test" # Role name
    groups   = ["test-namespace"] # Module output group name
  }]
```

3. Update eks config and check

```
aws eks update-kubeconfig --name <cluster-name> --role-arn <role-arn>
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.team](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.test-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role.k8s_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.k8s_bind_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | n/a | `string` | `"1658511"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | n/a | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | n/a | `string` | n/a | yes |
| <a name="input_rule"></a> [rule](#input\_rule) | n/a | `list(any)` | <pre>[<br>  {<br>    "api_groups": [<br>      "",<br>      "apps"<br>    ],<br>    "resources": [<br>      "pods",<br>      "pods/log",<br>      "configmaps",<br>      "services",<br>      "endpoints",<br>      "crontabs",<br>      "deployments",<br>      "nodes"<br>    ],<br>    "verbs": [<br>      "*"<br>    ]<br>  },<br>  {<br>    "api_groups": [<br>      "extensions"<br>    ],<br>    "resources": [<br>      "pods",<br>      "pods/log",<br>      "configmaps",<br>      "services",<br>      "endpoints",<br>      "crontabs",<br>      "deployments",<br>      "nodes"<br>    ],<br>    "verbs": [<br>      "*"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_usernames"></a> [usernames](#input\_usernames) | n/a | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_name"></a> [group\_name](#output\_group\_name) | n/a |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | n/a |
<!-- END_TF_DOCS -->
