# How To

Example 1:  Create Wildcard cerificate  
# Domain "The main domain"
# Alternative_domains "Subdomain or other main domain or wildcard domain"
# Zone "The main zone and equal to main domain"
# Alternative_zone "When you create alternative_domains, you must specify a zone of the same name, if you create wildcard can you use main domain."
```
module "ssl-certificate-auth" {
# source = "git::https://github.com/dasmeta/terraform.git//modules/aws-ssl-certificate?ref=aws-ssl-certificates"
  source = "../../../../dasmeta/terraform/modules/aws-ssl-certificate"

  domain              = "devops.dasmeta.com"
  alternative_domains = ["*.devops.dasmeta.com", "test9.devops.dasmeta.com"]
  zone                = "devops.dasmeta.com"
  alternative_zone   = ["devops.dasmeta.com","test9.devops.dasmeta.com"]
  tags = { 
    name   = "Environment"
    value = "prod"
  }

  providers {
    aws = aws.virginia
  }
}
```

Example 2: Create cert in different region (e.g. Cognito requirement).
```
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
}

module ssl-certificate-auth {
  # source = "git::https://github.com/dasmeta/terraform.git//modules/aws-ssl-certificate?ref=aws-ssl-certificates"
  source = "../../../../dasmeta/terraform/modules/aws-ssl-certificate"

  domain              = "devops.dasmeta.com"
  alternative_domains = ["*.devops.dasmeta.com", "test9.devops.dasmeta.com"]
  zone                = "devops.dasmeta.com"
  alternative_zone   = ["devops.dasmeta.com","test9.devops.dasmeta.com"]
  tags = { 
    name   = "Environment"
    value = "prod"
  }

  providers {
    aws = aws.virginia
  }
}
```
