<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 1.13.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks-cluster"></a> [eks-cluster](#module\_eks-cluster) | terraform-aws-modules/eks/aws | 17.24.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_user.user_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_enabled_log_types"></a> [cluster\_enabled\_log\_types](#input\_cluster\_enabled\_log\_types) | A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html) | `list(string)` | <pre>[<br>  "audit"<br>]</pre> | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | When you create EKS, API server endpoint access default is public. When you use private this variable value should be equal false | `bool` | `true` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Creating cluster name. | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Cluster version. | `string` | `"1.18"` | no |
| <a name="input_create_cluster"></a> [create\_cluster](#input\_create\_cluster) | Whether or not to create cluster. | `bool` | `true` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Whether or not to enable OpenID connect protocol. | `bool` | `true` | no |
| <a name="input_kubeconfig_output_path"></a> [kubeconfig\_output\_path](#input\_kubeconfig\_output\_path) | Where to put kubeconfig file. | `string` | `"./"` | no |
| <a name="input_manage_aws_auth"></a> [manage\_aws\_auth](#input\_manage\_aws\_auth) | n/a | `bool` | `true` | no |
| <a name="input_map_roles"></a> [map\_roles](#input\_map\_roles) | Additional IAM roles to add to the aws-auth configmap. | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of map of node groups to create. See `node_groups` module's documentation for more details | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | VPC subnets. Most probably those are the private ones. | `list(string)` | n/a | yes |
| <a name="input_users"></a> [users](#input\_users) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id where to spin up the cluster. | `string` | n/a | yes |
| <a name="input_worker_groups"></a> [worker\_groups](#input\_worker\_groups) | Worker groups. | `any` | <pre>[<br>  {<br>    "asg_max_size": 5,<br>    "instance_type": "t3.xlarge"<br>  }<br>]</pre> | no |
| <a name="input_worker_groups_launch_template"></a> [worker\_groups\_launch\_template](#input\_worker\_groups\_launch\_template) | A list of maps defining worker group configurations to be defined using AWS Launch Templates. See workers\_group\_defaults for valid keys. | `any` | `[]` | no |
| <a name="input_workers_group_defaults"></a> [workers\_group\_defaults](#input\_workers\_group\_defaults) | Worker group defaults. | `any` | <pre>{<br>  "kubelet_extra_args": "--node-labels=cluster_name=production,type=gpu_optimised --register-with-taints app=vums:NoSchedule",<br>  "root_volume_size": 50,<br>  "root_volume_type": "gp2"<br>}</pre> | no |
| <a name="input_write_kubeconfig"></a> [write\_kubeconfig](#input\_write\_kubeconfig) | Whether or not to create kubernetes config file. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate"></a> [certificate](#output\_certificate) | n/a |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | n/a |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | n/a |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | n/a |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | n/a |
| <a name="output_eks_oidc_root_ca_thumbprint"></a> [eks\_oidc\_root\_ca\_thumbprint](#output\_eks\_oidc\_root\_ca\_thumbprint) | Grab eks\_oidc\_root\_ca\_thumbprint from oidc\_provider\_arn. |
| <a name="output_host"></a> [host](#output\_host) | n/a |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_map_users_data"></a> [map\_users\_data](#output\_map\_users\_data) | n/a |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | n/a |
| <a name="output_token"></a> [token](#output\_token) | n/a |
| <a name="output_worker_iam_role_name"></a> [worker\_iam\_role\_name](#output\_worker\_iam\_role\_name) | n/a |
<!-- END_TF_DOCS -->