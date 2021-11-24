# Minimal usage example 1
This example creates an identity pool, named test-identity-1, with cognito provider.
```
module "identity" {
  source = "dasmeta/modules/aws//modules/cognito-identity"

  identity_pool_name = "test-identity-1"
  cognito_identity_providers = [
    {
        client_id               = "12abcd34ef5678ghij"
        provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAbbCC11"
    }
  ]
}
```

# Minimal usage example 2
This example creates an identity pool, named test-identity-2, with google provider.
```
module "identity" {
  source = "dasmeta/modules/aws//modules/cognito-identity"

  identity_pool_name = "test-identity-2"
  cognito_identity_providers = [
    {
        client_id               = "12abcd34ef5678ghij"
        provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAbbCC11"
    }
  ]

  supported_login_providers = {
    "accounts.google.com" = "123456789012.apps.googleusercontent.com"
  }
}
```

# Another usage example
This example creates an identity pool, named test-identity-3, with more than 1 cognito_identity_providers, google and facebook login providers, authenticated and unauthenticated roles. Also you can use amazon, twitter and digits as login providers.
```
module "identity" {
  source = "dasmeta/modules/aws//modules/cognito-identity"

  identity_pool_name = "test-identity-module-3"
  cognito_identity_providers = [
    {
        client_id               = "12abcd34ef5678ghij1"
        provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAbbCC111"
    },
    {
        client_id               = "12abcd34ef5678ghij2"
        provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAbbCC112"
    },
    {
        client_id               = "12abcd34ef5678ghij3"
        provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_AAbbCC113"
    }
  ]

  supported_login_providers = {
    "accounts.google.com" = "123456789012.apps.googleusercontent.com"
    "graph.facebook.com"  = "7346241598935552"
  }

  roles = {
      authenticated   = "arn:aws:iam::123456789012:role/some_auth_role"
      unauthenticated = "arn:aws:iam::123456789012:role/some_unauth_role"
  }

  role_mapping = {
    ambiguous_role_resolution = "Deny"
    identity_provider = "cognito-idp.us-east-1.amazonaws.com/us-east-1_abcdefghi:12abcd34ef5678ghij3"
    type = "Token"
  }
}
```
