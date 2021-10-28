module aws-cloudfront-security-headers {
  count = var.create_lambda_security_headers ? 1 : 0

  source = "../aws-cloudfront-security-headers"
  name   = "${substr(replace(var.domain_names[0], ".", "-"), 0, 32)}-security-headers"

  providers = {
    aws = aws.virginia
  }
}
