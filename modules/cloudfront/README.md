## Minimum usage example 

This example creates clodufront setup with a default origin only and uses S3 bucket. Also it has no custom certiifcate, as the `use_default_cert = true`.

```
module "cf" {
    source = "dasmeta/modules/aws//modules/cloudfront"
    origins = [
        {
          target = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
          type = "bucket"
          custom_origin_config = []
        }
    ] 
    use_default_cert = true
    default_target_origin_id = "some-s3-bucket-name.s3.us-east-1.amazonaws.com"
    domain_names = ["example.com"]
}
```

## example to create cloudfront and enable security headers lambda and set custom certificate

```
data "aws_s3_bucket" "selected" {
  bucket = "devops.dasmeta.com"

  provider = aws.virginia
}

data "aws_acm_certificate" "issued" {
  domain   = "devops.dasmeta.com"
  statuses = ["ISSUED"]

  provider = aws.virginia
}

module test-cloudfront {
  source = "dasmeta/modules/aws//modules/cloudfront"
  origins = [
      {
        target = data.aws_s3_bucket.selected.bucket_regional_domain_name
        type = "bucket"
        custom_origin_config = []
      }
  ]

  acm_cert_arn = data.aws_acm_certificate.issued.arn
  create_lambda_security_headers = true
  default_target_origin_id = data.aws_s3_bucket.selected.bucket_regional_domain_name
  lambda_function_name = "cloudfront-secure-headers-lambda"
  domain_names = ["devops.dasmeta.com"]
}
```

## Another usage example 

This example creates other origins except the default origin and uses not only s3, but also load balancers to do it. In the `origin` block you need to specify the type of the target for each item. There are 2 types: "alb", "bucket". Also if you want to create lambda function for security headers, set `create_lambda_security_headers = true`.

```
module "cloudfront" {
    source      = "dasmeta/modules/aws//modules/cloudfront"
    origins = [
        {
          target = "some-elb.eu-central-1.elb.amazonaws.com"
          type = "alb",
          custom_origin_config = [{
              http_port                = 80
              https_port               = 443
              origin_keepalive_timeout = 5
              origin_protocol_policy   = "http-only"
              origin_read_timeout      = 30
              origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
          }]
        },
        {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          type = "bucket"
          custom_origin_config = []
        }
    ]
    targets =  [
      {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          pattern = "/index.html"
      },
      {
          target = "some-bucket.s3.eu-central-1.amazonaws.com"
          pattern = "/static/*"
      },
      {
          target = "some-elb.eu-central-1.elb.amazonaws.com"
          pattern = "/"
      }
    ]
    acm_cert_arn = "some arn"
    create_lambda_security_headers = true
    lambda_function_name = "cloudfront-secure-headers-lambda"
    default_target_origin_id = "some-default-elb.eu-central-1.elb.amazonaws.com"
    domain_names = ["example.com"]
}
```
