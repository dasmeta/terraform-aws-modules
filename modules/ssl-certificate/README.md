# How To
This module creates SSL Certificates and can validate them in R53.

### Example 1: Basic
```
module "ssl-certificate-auth" {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain              = "example.com"
  zone                = "example.com"
}
```

### Example 2: Domain and Subdomain
```
module "ssl-certificate-auth" {

  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain              = "example.com"
  alternative_domains = ["*.example2.com"]
  zone                = "example.com"
  tags = {
      name    = "test"
      value   = "ssl"
  }
}
```

### Example 3: Single Certificate with Another Domain Name
```
module ssl-certificate-auth {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain              = "example.com"
  alternative_domains = ["sub.example.com", "example1.org", "*.example2.com"]
  zone                = "example.com"
  alternative_zone    = ["sub.example.com", "example1.org", "example2.com"]
  tags = {
      name    = "test"
      value   = "ssl"
  }
}
```

### Example 4: Certificate in a Different Region

```
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

module ssl-certificate-auth {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain              = "test.devops.dasmeta.com"
  alternative_domains = ["test1.devops.dasmeta.com"]
  zone                = "test.devops.dasmeta.com"
  alternative_zone   = ["test1.devops.dasmeta.com"]
  tags = {
      name = "test"
      value   = "test ssl"
  }

  providers {
    aws = aws.virginia
  }
}
```

### Example 5: Certificate without Validating it in R53
```
module "this" {
  source = "dasmeta/modules/aws//modules/ssl-certificate"

  validate = false
  domain          = "*.dasmeta.com"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alternative_domains"></a> [alternative\_domains](#input\_alternative\_domains) | Subdomain or other domain or wildcard for the certificate. | `list(string)` | `[]` | no |
| <a name="input_alternative_zones"></a> [alternative\_zones](#input\_alternative\_zones) | This variable uses route53. Must equal to alternative\_domains. (Note. When you use wildcard must be equal to main zone) | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Main domain name for ssl certificate. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags | `any` | `{}` | no |
| <a name="input_validate"></a> [validate](#input\_validate) | Whether validate the certificate in R53 zone or not. | `bool` | `true` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | R53 zone name where the certificate can be validated. Can be the same like domain | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SSL Certificate ARN to be used in ingress controllers |
| <a name="output_cname_records"></a> [cname\_records](#output\_cname\_records) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
