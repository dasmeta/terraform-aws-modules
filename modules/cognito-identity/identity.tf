resource "aws_cognito_identity_pool" "identity" {
    identity_pool_name               = var.identity_pool_name
    allow_classic_flow               = var.allow_classic_flow
    allow_unauthenticated_identities = var.allow_unauthenticated_identities

    dynamic "cognito_identity_providers" {
        for_each = var.cognito_identity_providers
        
        content {
            client_id               = cognito_identity_providers.value.client_id
            provider_name           = cognito_identity_providers.value.provider_name
            server_side_token_check = false
        }
    }

    supported_login_providers = var.supported_login_providers
}
