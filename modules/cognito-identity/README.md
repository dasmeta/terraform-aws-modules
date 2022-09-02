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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                        | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_cognito_identity_pool.identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool)                                     | resource |
| [aws_cognito_identity_pool_roles_attachment.attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment) | resource |

## Inputs

| Name                                                                                                                              | Description                                                                                                                                                                                                                                                         | Type       | Default                                                                                                                                                                | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_allow_classic_flow"></a> [allow_classic_flow](#input_allow_classic_flow)                                           | Enables or disables the classic / basic authentication flow.                                                                                                                                                                                                        | `bool`     | `true`                                                                                                                                                                 |    no    |
| <a name="input_allow_unauthenticated_identities"></a> [allow_unauthenticated_identities](#input_allow_unauthenticated_identities) | Whether the identity pool supports unauthenticated logins or not.                                                                                                                                                                                                   | `bool`     | `false`                                                                                                                                                                |    no    |
| <a name="input_cognito_identity_providers"></a> [cognito_identity_providers](#input_cognito_identity_providers)                   | An array of Amazon Cognito Identity user pools and their client IDs.                                                                                                                                                                                                | `list`     | <pre>[<br> {<br> "client_id": null,<br> "provider_name": null,<br> "server_side_token_check": false<br> }<br>]</pre>                                                   |    no    |
| <a name="input_identity_pool_name"></a> [identity_pool_name](#input_identity_pool_name)                                           | The Cognito Identity Pool name.                                                                                                                                                                                                                                     | `string`   | `""`                                                                                                                                                                   |    no    |
| <a name="input_role_mapping"></a> [role_mapping](#input_role_mapping)                                                             | ambiguous_role_resolution specifies the action to be taken if either no rules match the claim value for the Rules type, or there is no cognito:preferred_role claim and there are multiple cognito:roles matches for the Token type. type is the role mapping type. | `map(any)` | <pre>{<br> "ambiguous_role_resolution": "",<br> "identity_provider": "",<br> "type": ""<br>}</pre>                                                                     |    no    |
| <a name="input_roles"></a> [roles](#input_roles)                                                                                  | The map of roles associated with the identity pool. Each value will be the Role ARN.                                                                                                                                                                                | `map(any)` | <pre>{<br> "authenticated": "",<br> "unauthenticated": ""<br>}</pre>                                                                                                   |    no    |
| <a name="input_supported_login_providers"></a> [supported_login_providers](#input_supported_login_providers)                      | Key-Value pairs mapping provider names to provider app IDs.                                                                                                                                                                                                         | `map(any)` | <pre>{<br> "accounts.google.com": null,<br> "api.twitter.com": null,<br> "graph.facebook.com": null,<br> "www.amazon.com": null,<br> "www.digits.com": null<br>}</pre> |    no    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
