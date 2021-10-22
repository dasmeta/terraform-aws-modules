resource "aws_cognito_identity_pool" "identity-pool" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = var.allow_unauthenticated_identities
  allow_classic_flow               = var.allow_classic_flow

  cognito_identity_providers {
    client_id               = "${aws_cognito_user_pool_client.client.id}"
    provider_name           = "${aws_cognito_user_pool.user-pool.endpoint}"
    server_side_token_check = false
  }
}
