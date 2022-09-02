<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# Why

Terraform module to export container logs from EKS to S3

## Example

```
module "fluent-bit" {
  source = "../fluent-bit-to-s3"

  fluent_bit_name             = "fluent-bit"
  bucket_name                 = "fluent-bit-cloudwatch-354242324"
  cluster_name                = ""
  eks_oidc_root_ca_thumbprint = module.eks-cluster.eks_oidc_root_ca_thumbprint
  oidc_provider_arn           = module.eks-cluster.oidc_provider_arn

  cluster_host        = module.eks-cluster.host
  cluster_certificate = module.eks-cluster.certificate
  cluster_token       = module.eks-cluster.token
  region              = data.aws_region.current.name
}
```

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | ~> 1.0   |
| <a name="requirement_helm"></a> [helm](#requirement_helm)                | ~> 2.4.0 |

## Providers

| Name                                                                  | Version  |
| --------------------------------------------------------------------- | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                      | n/a      |
| <a name="provider_helm"></a> [helm](#provider_helm)                   | ~> 2.4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | n/a      |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                 | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                                        | resource    |
| [aws_iam_role.fluent-bit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                      | resource    |
| [aws_iam_role_policy_attachment.CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [helm_release.fluent-bit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)                                                      | resource    |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace)                                       | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                        | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                          | data source |

## Inputs

| Name                                                                                                               | Description                                                         | Type     | Default                   | Required |
| ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------- | -------- | ------------------------- | :------: |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name)                                                 | S3 bucket name fluent-bit should stream logs into.                  | `string` | `"fluentbit-bucket-name"` |    no    |
| <a name="input_cluster_certificate"></a> [cluster_certificate](#input_cluster_certificate)                         | n/a                                                                 | `string` | n/a                       |   yes    |
| <a name="input_cluster_host"></a> [cluster_host](#input_cluster_host)                                              | Auth data                                                           | `string` | n/a                       |   yes    |
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name)                                              | EKS cluster name fluent-bit will be installed in.                   | `string` | n/a                       |   yes    |
| <a name="input_cluster_token"></a> [cluster_token](#input_cluster_token)                                           | n/a                                                                 | `string` | n/a                       |   yes    |
| <a name="input_create_namespace"></a> [create_namespace](#input_create_namespace)                                  | Wether or no to create namespace if namespace does not exist.       | `bool`   | `false`                   |    no    |
| <a name="input_eks_oidc_root_ca_thumbprint"></a> [eks_oidc_root_ca_thumbprint](#input_eks_oidc_root_ca_thumbprint) | n/a                                                                 | `string` | n/a                       |   yes    |
| <a name="input_fluent_bit_name"></a> [fluent_bit_name](#input_fluent_bit_name)                                     | Fluent-bit chart release name.                                      | `string` | `"fluent-bit"`            |    no    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                                                       | Namespace fluent-bit should be deployed into.                       | `string` | `"kube-system"`           |    no    |
| <a name="input_oidc_provider_arn"></a> [oidc_provider_arn](#input_oidc_provider_arn)                               | n/a                                                                 | `string` | n/a                       |   yes    |
| <a name="input_region"></a> [region](#input_region)                                                                | AWS Region logs should be streamed to (defaults to current region). | `string` | `"eu-central-1"`          |    no    |
| <a name="input_role_name"></a> [role_name](#input_role_name)                                                       | AWS IAM Role fluent-bit will be using to stream logs.               | `string` | `"logger"`                |    no    |

## Outputs

| Name                                                                             | Description |
| -------------------------------------------------------------------------------- | ----------- |
| <a name="output_assume_role_arn"></a> [assume_role_arn](#output_assume_role_arn) | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
