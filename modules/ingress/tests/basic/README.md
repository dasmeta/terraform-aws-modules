# basic

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.41 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.41 |
| <a name="provider_test"></a> [test](#provider\_test) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| test_assertions.dummy | resource |
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
