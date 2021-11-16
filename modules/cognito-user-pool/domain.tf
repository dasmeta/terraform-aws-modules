# resource "aws_cognito_user_pool_domain" "main" {
#   domain          = var.domain
#   certificate_arn = var.cert_arn
#   user_pool_id    = aws_cognito_user_pool.pool.id
# }

# data "aws_route53_zone" "example" {
#   name = var.r53_zone
# }

# resource "aws_route53_record" "auth-cognito-A" {
#   name    = aws_cognito_user_pool_domain.main.domain
#   type    = "A"
#   zone_id = data.aws_route53_zone.example.zone_id
#     alias {
#     evaluate_target_health = false
#     name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
#     # This zone_id is fixed
#     zone_id = "Z2FDTNDATAQYW2"
#   }
# }
