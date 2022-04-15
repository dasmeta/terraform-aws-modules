resource "aws_cognito_user_pool_domain" "main" {
  count = (var.domain != "") ? 1 : 0

  domain          = var.domain
  certificate_arn = var.cert_arn
  user_pool_id    = aws_cognito_user_pool.pool.id
}

resource "aws_route53_record" "auth-cognito-A" {
  count = var.create_route53_record ? 1 : 0

  name    = aws_cognito_user_pool_domain.main[0].domain
  type    = "A"
  zone_id = var.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.main[0].cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}
