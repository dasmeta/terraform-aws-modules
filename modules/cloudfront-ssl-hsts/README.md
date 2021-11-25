```hcl
provider "aws" {
  region = "us-east-1"
}

module "cdn" {
  source = "dasmeta/modules/aws//modules/cloudfront-ssl-hsts"
  zone    = ["devops.dasmeta.com"]
  aliases = ["cdn.devops.dasmeta.com"]
  comment             = "My CloudFront"
  
  origin = {
    alb = {
      domain_name = "alb dns"
    }
  }

  default_cache_behavior = {
    target_origin_id           = "alb"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/alb"
      target_origin_id       = "alb"
    },
    {
      path_pattern           = "/alb2"
      target_origin_id       = "alb"
    }
  ]

}
```