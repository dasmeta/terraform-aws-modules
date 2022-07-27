module "vpn" {
  source                     = "../aws-vpn-vpnendpoint"
  enable_saml                = var.enable_saml
  vpc_id                     = var.vpc_id
  endpoint_name              = var.endpoint_name
  endpoint_client_cidr_block = var.endpoint_client_cidr_block
  saml_provider_arn          = var.saml_provider_arn
  certificate_arn            = var.certificate_arn
  endpoint_subnets           = var.endpoint_subnets
  authorization_ingress      = var.authorization_ingress
  tags = {
    "Name" = var.endpoint_name
  }
}
