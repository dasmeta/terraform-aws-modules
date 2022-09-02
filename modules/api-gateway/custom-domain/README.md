# custom-domain

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
| <a name="module_certificate_edge"></a> [certificate\_edge](#module\_certificate\_edge) | dasmeta/modules/aws//modules/ssl-certificate | 0.34.0 |
| <a name="module_certificate_regional"></a> [certificate\_regional](#module\_certificate\_regional) | dasmeta/modules/aws//modules/ssl-certificate | 0.34.0 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.custom_domain_api_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_domain_name.custom_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.custom_domain_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | The API Gateway id | `string` | n/a | yes |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one | <pre>object({<br>    name      = string # this is just first part of domain without zone part<br>    zone_name = string<br>  })</pre> | <pre>{<br>  "name": "",<br>  "zone_name": ""<br>}</pre> | no |
| <a name="input_endpoint_config_type"></a> [endpoint\_config\_type](#input\_endpoint\_config\_type) | API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE | `string` | `"REGIONAL"` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | The API Gateway stage name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
