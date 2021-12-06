
# example with ALB default and 2 more cache behaviors:
```hcl
provider "aws" {
  region = "us-east-1"
}

module "cdn" {
  source = "dasmeta/modules/aws//modules/cloudfront-ssl-hsts"
  version = "0.19.5"

  zone    = ["devops.dasmeta.com"]
  aliases = ["cdn.devops.dasmeta.com"]
  comment             = "My CloudFront"
  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = "logs-my-cdn.s3.amazonaws.com"
  }

  origin = {
    alb = {
      domain_name = "alb dns"
      custom_origin_config = {
        origin_ssl_protocols   = ["TLSv1.2"]
      }
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

# sample with S3 default cache behavior
 ```hcl
provider "aws" {
  region = "us-east-1"
}

module "cdn" {
  source = "dasmeta/modules/aws//modules/cloudfront-ssl-hsts"
  version = "0.19.5"

  zone    = ["devops.dasmeta.com"]
  aliases = ["cdn.devops.dasmeta.com"]
  comment = "My CloudFront"

  origin = {
    s3 = {
      domain_name = "S3 website URL" # you need to enable S3 website to have this
      custom_origin_config = {
        origin_protocol_policy = "http-only"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id = "s3"
    use_forwarded_values = true
    headers = [] # the default value is ["*"] and S3 origin do not support it, so we just need to disable it
  }
}
```
