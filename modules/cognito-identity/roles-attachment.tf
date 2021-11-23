resource "aws_cognito_identity_pool_roles_attachment" "attachment" {
    count            = (var.roles.authenticated != "" && var.roles.unauthenticated != "") ? 1 : 0
    
    identity_pool_id = aws_cognito_identity_pool.identity.id
    roles            = {
        "authenticated"   = var.roles.authenticated
        "unauthenticated" = var.roles.unauthenticated
    }

    role_mapping {
        ambiguous_role_resolution = var.role_mapping.ambiguous_role_resolution
        identity_provider         = var.role_mapping.identity_provider
        type                      = var.role_mapping.type
    }
}
