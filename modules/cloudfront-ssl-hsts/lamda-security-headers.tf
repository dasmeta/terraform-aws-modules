module "aws-cloudfront-security-headers" {
  count = var.create_hsts ? 1 : 0

  source  = "dasmeta/modules/aws//modules/aws-cloudfront-security-headers"
  version = "0.23.1"

  name                    = "${substr(replace(var.aliases[0], ".", "-"), 0, 32)}-security-headers"
  override_custom_headers = var.override_custom_headers
  runtime                 = "nodejs18.x"
}
