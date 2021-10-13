## Minimum usage example 

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
    default_target_origin_id = "some-default-elb.eu-central-1.elb.amazonaws.com"
}
