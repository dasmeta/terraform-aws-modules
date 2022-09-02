# How to use

```
module "secret-store" {
  source = "dasmeta/terraform/modules/external-secret-store"

  name = "store-name"
}
```

This is going to create AWS IAM User and restric access to Secret Manager keys starting with store-name (e.g. store-name-\*).
Any secret created in Secret Manager matching the prefix can be requested via that External Secret Store and be populated as a Secret.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13  |
| <a name="requirement_kubectl"></a> [kubectl](#requirement_kubectl)       | >= 1.7.0 |

## Providers

| Name                                                                  | Version  |
| --------------------------------------------------------------------- | -------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                      | n/a      |
| <a name="provider_kubectl"></a> [kubectl](#provider_kubectl)          | >= 1.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider_kubernetes) | n/a      |

## Modules

| Name                                                        | Source                                          | Version |
| ----------------------------------------------------------- | ----------------------------------------------- | ------- |
| <a name="module_iam-user"></a> [iam-user](#module_iam-user) | terraform-aws-modules/iam/aws//modules/iam-user | 4.6.0   |

## Resources

| Name                                                                                                                                                 | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                      | resource    |
| [aws_iam_user_policy_attachment.test-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource    |
| [kubectl_manifest.main](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest)                                  | resource    |
| [kubernetes_secret.store-secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret)                          | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                        | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                          | data source |

## Inputs

| Name                                                                                 | Description                                                                                              | Type     | Default     | Required |
| ------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------- | -------- | ----------- | :------: |
| <a name="input_aws_access_key_id"></a> [aws_access_key_id](#input_aws_access_key_id) | The key store will be using to pull secrets from AWS Secret Manager.                                     | `string` | `""`        |    no    |
| <a name="input_aws_access_secret"></a> [aws_access_secret](#input_aws_access_secret) | The secret store will be using to pull secrets from AWS Secret Manager.                                  | `string` | `""`        |    no    |
| <a name="input_aws_role_arn"></a> [aws_role_arn](#input_aws_role_arn)                | Role ARN used to pull secrets from Secret Manager.                                                       | `string` | `""`        |    no    |
| <a name="input_controller"></a> [controller](#input_controller)                      | Not sure what is this for yet.                                                                           | `string` | `"dev"`     |    no    |
| <a name="input_create_user"></a> [create_user](#input_create_user)                   | Create IAM user to read credentials or aws_access_key_id / aws_access_secret combination should be used. | `bool`   | `true`      |    no    |
| <a name="input_name"></a> [name](#input_name)                                        | Secret store name.                                                                                       | `string` | n/a         |   yes    |
| <a name="input_namespace"></a> [namespace](#input_namespace)                         | n/a                                                                                                      | `string` | `"default"` |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
