resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.identity-pool.id
  roles = {
    "authenticated" = aws_iam_role.authenticated.arn
  }
}
