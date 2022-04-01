# How To
This module you can use , when create domain certificate


### Example 1:  You can use this case when create a wildcard certificate or other subdomain certificate.

```
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."

module "ssl-certificate-auth" {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  domain              = "example.com"
  zone                = "example.com"
}

or 

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
### Example 2: You can use this case when you create a single certificate և add different subdomains or another domain name
```
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."

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
### Example 3: You can use this case when you create certificate different region.
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
<!-- BEGIN_TF_DOCS -->
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
| <a name="input_alternative_domains"></a> [alternative\_domains](#input\_alternative\_domains) | Subdomain or other domain or wildcard certificate name will be create. | `list(string)` | `[]` | no |
| <a name="input_alternative_zones"></a> [alternative\_zones](#input\_alternative\_zones) | This variable use route53. Must equal to alternative\_domains. (Note. When you use wildcard must be equal to main zone) | `list(string)` | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Main domain name ssl certificate. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags | `any` | `{}` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | This variable use route53. Can equal to main domain name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | SSL Certificate ARN to be used in ingress controllers |
<!-- END_TF_DOCS -->