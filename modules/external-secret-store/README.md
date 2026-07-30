# external-secret-store

Creates an External Secrets `SecretStore` (or `ClusterSecretStore`) backed by AWS Secrets
Manager, plus the least-privilege IAM role it uses.

```hcl
module "secret_store" {
  source = "./modules/external-secret-store"

  name                = "app/prod"
  controller_role_arn = module.external_secrets.controller_role_arn
  kind                = "SecretStore"
  namespace           = "kube-system"
}
```

## Auth model (no static credentials)

This module has been adapted from the upstream dasmeta module to **remove the IAM user +
static access-key mechanism**. Instead:

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

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| `name` | Store name; IAM scope is `secret:<name>*`. | — | yes |
| `controller_role_arn` | Controller base role ARN the store role trusts. | — | yes |
| `kind` | `SecretStore` or `ClusterSecretStore`. | `SecretStore` | no |
| `namespace` | Namespace for a `SecretStore`. | `kube-system` | no |
| `region` | Provider region. | current region | no |
| `external_secrets_api_version` | Store resource apiVersion. | `external-secrets.io/v1` | no |
| `prefix` | Per-region uniqueness prefix for the global IAM role name. | `""` | no |
| `store_role_name_prefix` | Role-name prefix (must match the controller grant). | `external-secrets-store-` | no |
