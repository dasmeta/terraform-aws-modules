# How To
This module you can use , when create domain certificate


### Example 1:  You can use this case when create a wildcard certificate or other subdomain certificate.

```
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."

module "ssl-certificate-auth" {

  source = "dasmeta/modules/aws//modules/cloudfront"
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
  source = "dasmeta/modules/aws//modules/aws-ssl-certificate"
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
  source = "dasmeta/modules/aws//modules/aws-ssl-certificate"
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