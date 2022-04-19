resource "aws_cognito_user_group" "group" {
  count = (var.user_group != "") ? 1 : 0

  name         = var.user_group
  user_pool_id = aws_cognito_user_pool.pool.id
  precedence   = var.precedence
  role_arn     = var.role_arn
}
