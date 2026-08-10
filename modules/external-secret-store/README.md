# external-secret-store

Creates an External Secrets `SecretStore` (or `ClusterSecretStore`) backed by AWS Secrets
Manager, plus the least-privilege IAM role it uses.

## Basic usage

The store needs the External Secrets controller's base role ARN, which the dasmeta EKS module
exposes as an output. `store_role_name_prefix` must match on both sides, otherwise the
controller's `sts:AssumeRole` grant will not cover this store's role.

```hcl
module "eks" {
  source  = "dasmeta/eks/aws"
  version = "2.28.0"

  cluster_name = "example"
}

module "secret_store" {
  source  = "dasmeta/modules/aws//modules/external-secret-store"
  version = "2.20.0"

  name      = "app/prod" # IAM access is scoped to Secrets Manager secrets named app/prod*
  namespace = "prod"

  controller_role_arn    = module.eks.external_secrets.controller_role_arn
  store_role_name_prefix = module.eks.external_secrets.store_role_name_prefix

  depends_on = [module.eks]
}
```

A `ClusterSecretStore` is the same call with `kind = "ClusterSecretStore"`; the namespace is
ignored for that kind because the resource is cluster scoped.

## Auth model (no static credentials)

Earlier versions of this module created an IAM user per store, generated an access key, wrote it
into a Kubernetes Secret and pointed the store at it through `spec.provider.aws.auth.secretRef`.
That put long-lived static credentials in both the cluster and Terraform state, once per store,
with no rotation. That mechanism has been removed. Instead:

- It creates a per-store IAM **role** (`<store_role_name_prefix><prefix><name>`) whose trust
  policy allows only the external-secrets controller's base role (`controller_role_arn`) to
  assume it.
- The role is granted read-only access (`secretsmanager:GetSecretValue`, `GetResourcePolicy`,
  `DescribeSecret`, `ListSecretVersionIds`) scoped to `secret:<name>*`.
- The generated `SecretStore` sets `spec.provider.aws.role = <role_arn>`, so the controller
  (running with EKS Pod Identity / IRSA credentials) assumes this role to read the store's
  secrets. No `secretRef`, no IAM user, no access keys.

The controller module grants its base role `sts:AssumeRole` on `role/<store_role_name_prefix>*`,
so `store_role_name_prefix` here must match the controller's.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.store](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubectl_manifest.main](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_controller_role_arn"></a> [controller\_role\_arn](#input\_controller\_role\_arn) | ARN of the external-secrets controller's base IAM role. The store role trusts this principal so the controller can assume it (role chaining via spec.provider.aws.role). No static credentials are used. | `string` | n/a | yes |
| <a name="input_external_secrets_api_version"></a> [external\_secrets\_api\_version](#input\_external\_secrets\_api\_version) | apiVersion for the SecretStore/ClusterSecretStore resource (chart 2.8.0 ships external-secrets.io/v1). | `string` | `"external-secrets.io/v1"` | no |
| <a name="input_kind"></a> [kind](#input\_kind) | SecretStore (namespaced) or ClusterSecretStore (cluster-wide). | `string` | `"SecretStore"` | no |
| <a name="input_name"></a> [name](#input\_name) | Secret store name. The store's IAM role is scoped to AWS Secrets Manager secrets whose name starts with this value (e.g. "app/prod" -> "app/prod*"). | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for a SecretStore (ignored for ClusterSecretStore). | `string` | `"kube-system"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Uniqueness prefix for the store's global IAM role name (needed for multi-region setups since IAM is global). | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region for the SecretsManager provider; defaults to the current region when empty. | `string` | `""` | no |
| <a name="input_store_role_name_prefix"></a> [store\_role\_name\_prefix](#input\_store\_role\_name\_prefix) | Naming prefix for the store IAM role. Must match the controller's store\_role\_name\_prefix so the controller's sts:AssumeRole grant covers it. | `string` | `"external-secrets-store-"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kind"></a> [kind](#output\_kind) | Store kind (SecretStore or ClusterSecretStore). |
| <a name="output_name"></a> [name](#output\_name) | Sanitized SecretStore/ClusterSecretStore resource name. |
| <a name="output_store_role_arn"></a> [store\_role\_arn](#output\_store\_role\_arn) | ARN of the per-store IAM role the controller assumes for this store. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
