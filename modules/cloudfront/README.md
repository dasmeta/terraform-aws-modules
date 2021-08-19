```
module cloudfront {
  source = "git..../modules/aws/cloudfront"

  distribution = {
    is_ipv6_enabled = true
  }

  route53 = {
    enabled = false
  }

  bucket = {
    enabled = false
  }

  certificate = {
    enabled = false
    create = false or certificate-arn = ""
  }
}
