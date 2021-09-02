data "aws_vpc" "my-vpn" {
  id = module.vpc.vpc_id
}

resource "aws_cloudwatch_log_group" "my-vpn" {
  name              = "${var.cloudwatch_log_group_name_prefix}${var.endpoint_name}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  tags              = var.tags
  depends_on = [module.vpc]
}

resource "aws_cloudwatch_log_stream" "my-vpn" {
  log_group_name = aws_cloudwatch_log_group.my-vpn.name
  name           = "connection-log"
  depends_on = [module.vpc]
}
resource "aws_ec2_client_vpn_endpoint" "my-vpn_sso" {
  description            = var.endpoint_name
  server_certificate_arn = var.certificate_arn
  client_cidr_block      = var.endpoint_client_cidr_block
  split_tunnel           = true
  transport_protocol     = "udp"
  dns_servers            = [cidrhost(data.aws_vpc.my-vpn.cidr_block, 2)]
  authentication_options {
    type              = "federated-authentication"
    saml_provider_arn = var.saml_provider_arn
  }
  depends_on = [module.vpc]
  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.my-vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.my-vpn.name
  }
  tags = merge(
    {
      Name = var.endpoint_name
    },
    var.tags,
  )
}

resource "aws_security_group" "my-vpn" {
  name        = "client-vpn-endpoint-${var.endpoint_name}"
  description = "Egress All. Used for other groups where VPN access is required. "
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
  depends_on = [module.vpc]
}
resource "aws_ec2_client_vpn_network_association" "my-vpn_sso" {
  for_each               = toset(module.vpc.private_subnets)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  subnet_id              = each.value
  security_groups        = [aws_security_group.my-vpn.id]
  depends_on = [module.vpc]
}
resource "aws_ec2_client_vpn_authorization_rule" "my-vpn_sso_to_dns" {
  for_each               = toset(var.authorization_ingress)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  target_network_cidr    = each.value
  authorize_all_groups   = true
  description            = "Authorization for ${var.endpoint_name} to DNS"
  depends_on = [module.vpc]
 } 
resource "aws_ec2_client_vpn_route" "my-vpn_sso" {
  for_each               = var.additional_routes
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  destination_cidr_block = each.value
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.my-vpn_sso[each.key].subnet_id
  description            = "From ${each.key} to ${each.value}"
  depends_on             = [module.vpc]
}

resource "aws_vpc_peering_connection" "vpn_peering" {
  for_each               = var.peering_vps_ids
  vpc_id                 = module.vpc.vpc_id
  peer_vpc_id            = each.value

  auto_accept = true
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.6.0"
  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = var.availability_zones
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

}
