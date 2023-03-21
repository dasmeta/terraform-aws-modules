# basic

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_test"></a> [test](#provider\_test) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_goldilocks"></a> [goldilocks](#module\_goldilocks) | ../../ | n/a |
| <a name="module_goldilocks-cognito"></a> [goldilocks-cognito](#module\_goldilocks-cognito) | dasmeta/modules/aws//modules/cognito-user-pool/ | 0.26.2 |
| <a name="module_ssl-certificate-auth"></a> [ssl-certificate-auth](#module\_ssl-certificate-auth) | dasmeta/modules/aws//modules/ssl-certificate | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.www](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| test_assertions.dummy | resource |
| [aws_lb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb) | data source |
| [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
