### Ingress and ALB with R53
This example creates an Ingress resource with its default values, and creates an ALB. Then it uses ALB as the value for a R53 record in an existing zone.
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ../.. | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | dasmeta/modules/aws//modules/route53 | 0.21.17 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_ingress_v1.example](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/ingress_v1) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
