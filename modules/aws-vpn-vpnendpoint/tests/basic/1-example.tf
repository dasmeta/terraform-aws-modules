
module "vpn_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "my_vpn_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.10.0/24"]

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
}

module "vpn" {
  source = "../../"

  # VPN Endpoint
  vpc_id                     = module.vpn_vpc.vpc_id
  endpoint_name              = "my_test"
  endpoint_client_cidr_block = "30.0.0.0/16"
  saml_provider_arn          = ""
  certificate_arn            = "arn:aws:acm:eu-central-1:xxxxx:certificate/yyy-yyyy-yyyy-yyyy-yyyyyyyyyyyyy"
  client_certificate_arn     = "arn:aws:acm:eu-central-1:yyyyy:certificate/zzz-zzzz-zzzz-zzzz-zzzzzzzzzzzzz"

  // Accept traffic to cidrs
  authorization_ingress = ["172.17.0.0/16", "0.0.0.0/0"]
  endpoint_subnets = [
    module.vpn_vpc.private_subnets[0]
  ]
  additional_routes = {
    test = {
      cidr      = "172.17.0.0/16"
      subnet_id = module.vpn_vpc.private_subnets[0]
    }
  }

  split_tunnel    = false
  peering_vpc_ids = ["vpc-xxxxxxxxxxxxx"]
  vpn_port        = 1194

  providers = {
    aws      = aws
    aws.peer = aws
  }
}
