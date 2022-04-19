resource "aws_cognito_user_pool_client" "client" {
  for_each = toset(var.clients)

  name            = each.value
  generate_secret = var.generate_secret
  user_pool_id    = aws_cognito_user_pool.pool.id

  access_token_validity                = var.access_token_validity
  allowed_oauth_flows_user_pool_client = var.allowed_oauth_flows_user_pool_client
  enable_token_revocation              = var.enable_token_revocation
  explicit_auth_flows                  = var.explicit_auth_flows
  id_token_validity                    = var.id_token_validity
  prevent_user_existence_errors        = var.prevent_user_existence_errors
  read_attributes                      = var.read_attributes
  refresh_token_validity               = var.refresh_token_validity
  write_attributes                     = var.write_attributes
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  supported_identity_providers         = var.supported_identity_providers
  token_validity_units {
    access_token  = var.token_validity_units.access_token
    id_token      = var.token_validity_units.id_token
    refresh_token = var.token_validity_units.refresh_token
  }
}
