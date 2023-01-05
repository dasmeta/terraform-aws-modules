locals {
  // Vpn Config
  vpn_name = "vpn"
  vpn_cidr = "30.0.0.0/16"

  //
  saml_provider_arn          = "arn:aws:iam::565580475168:saml-provider/AWSSSO_e2b6afaecadb9714_DO_NOT_DELETE"
  vpn_server_certificate_arn = "arn:aws:acm:eu-central-1:565580475168:certificate/0bc55771-9e93-4a78-a765-51682c3a10e7"

  vpn_accepted_traffics = ["172.17.0.0/16"]

  split_tunnel    = true
  peering_vpc_ids = []
  vpn_port        = 443
}

module "vpn" {
  source = "../../"

  # VPN Endpoint
  vpc_id                     = "vpc-0700c9086ddf371cb"
  endpoint_name              = local.vpn_name
  endpoint_client_cidr_block = local.vpn_cidr
  saml_provider_arn          = local.saml_provider_arn
  certificate_arn            = local.vpn_server_certificate_arn

  // Accept traffic to cidrs
  endpoint_subnets = [
    "subnet-04bb6697b5c8c3c2c"
  ]
  additional_routes = { for item in local.vpn_accepted_traffics :
    item => {
      cidr      = item
      subnet_id = "subnet-04bb6697b5c8c3c2c"
    }
  }

  split_tunnel    = local.split_tunnel
  peering_vpc_ids = local.peering_vpc_ids
  vpn_port        = local.vpn_port

  providers = {
    aws      = aws
    aws.peer = aws
  }
}
