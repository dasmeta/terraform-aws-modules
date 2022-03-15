
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
    something = {
      domain_name = "something.example.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_one = {
      domain_name = "my-s3-bycket.s3.amazonaws.com"
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
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
