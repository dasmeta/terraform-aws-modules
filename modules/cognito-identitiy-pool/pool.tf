resource "aws_iam_saml_provider" "default" {
  name                   = "my-saml-provider"
  saml_metadata_document = file("saml-metadata.xml")
}

resource "aws_cognito_identity_pool" "main" {
  identity_pool_name               = var.name
  allow_unauthenticated_identities = false
  allow_classic_flow               = false

  cognito_identity_providers {
    client_id               = "6lhlkkfbfb4q5kpp90urffae"
    provider_name           = "cognito-idp.us-east-1.amazonaws.com/us-east-1_Tv0493apJ"
    server_side_token_check = false
  }

  cognito_identity_providers {
    client_id               = "7kodkvfqfb4qfkp39eurffae"
    provider_name           = "cognito-idp.us-east-1.amazonaws.com/eu-west-1_Zr231apJu"
    server_side_token_check = false
  }

  supported_login_providers = {
    "graph.facebook.com"  = "7346241598935552"
    "accounts.google.com" = "123456789012.apps.googleusercontent.com"
  }

  saml_provider_arns           = [aws_iam_saml_provider.default.arn]
  openid_connect_provider_arns = ["arn:aws:iam::123456789012:oidc-provider/id.example.com"]
}
