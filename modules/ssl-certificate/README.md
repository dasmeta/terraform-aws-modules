# How To


### Example 1:  Create cerificate or subdomian certificate or wildcard certificate

```
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."

module "ssl-certificate-auth" {
  source = ".dasmeta/modules/aws//modules/cloudfront"

  domain              = "example.com"
  alternative_domains = ["sub.example.com", "example1.org", "*.example2.com"]
  zone                = "example.com"
  alternative_zone   = ["sub.example.com", "example1.org", "example2.com"]
  tags = var.tags

}
```

### Example 2: Create cerificate or subdomian certificate or wildcard certificate for CloudFront.
```
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."

provider "aws" {

  region  = "us-east-1"
}

module ssl-certificate-auth {
  source = "dasmeta/modules/aws//modules/aws-ssl-certificate"

  domain              = "example.com"
  alternative_domains = ["sub.example.com", "example1.org", "*.example2.com"]
  zone                = "example.com"
  alternative_zone   = ["sub.example.com", "example1.org", "example2.com"]
  tags = {
      name = "test"
      value   = "test ssl"
  }
  
}
```
