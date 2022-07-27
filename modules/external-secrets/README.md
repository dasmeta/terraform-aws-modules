# How to use
This needs to be included in eks cluster along side with other services.

At this stage it does not require any credentials.

```
module external-secrets-staging {
  source = "dasmeta/terraform/modules/external-secrets"
}
```

After this one has to deploy specific stores which do contain credentials to pull secrets from AWS Secret Manager.

See related modules:
- external-secret-store
- aws-secret

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_release"></a> [release](#module\_release) | terraform-module/release/helm | 2.7.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | <pre>object({<br>    host        = string<br>    certificate = string<br>    token       = string<br>  })</pre> | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace of kubernetes resources | `string` | `"kube-system"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
