### Add paths to Ingress with K8s
This example creates an Ingress with Terraform for an existing domain. Terraform attaches `alb.ingress.kubernetes.io/group.name` to the resource by default and its value is ${local.name}.
The main purpose of `ingress` module is to manage ingress resource from Terraform but edit/use/configure it from k8s side.
So there is an `ingress.yaml` file where `alb.ingress.kubernetes.io/group.name` is set and has the same value as Ingress created by Terraform.
In this way these 2 ingresses are attached to the same ALB.


## Usage

To run this example you first need to execute these commands for Terraform:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

and then this one for K8s:
```bash
kubectl apply -f ingress.yaml
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.issued](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
