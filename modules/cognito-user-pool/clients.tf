resource "aws_cognito_user_pool_client" "client" {
  for_each = toset(var.clients)
  name = each.value

  user_pool_id = aws_cognito_user_pool.pool.id
}
