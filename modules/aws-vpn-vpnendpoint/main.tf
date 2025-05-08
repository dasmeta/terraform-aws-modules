locals {
  dns_servers = length(var.dns_servers) == 0 ? [cidrhost(data.aws_vpc.my-vpn.cidr_block, 2)] : concat([cidrhost(data.aws_vpc.my-vpn.cidr_block, 2)], var.dns_servers)
}

data "aws_vpc" "my-vpn" {
  id = var.vpc_id
}

module "vpc_multi_peering" {
  source = "../aws-multi-vpc-peering/"

  main_vpc       = var.vpc_id
  peering_vpc_id = var.peering_vpc_ids

  providers = {
    aws      = aws
    aws.peer = aws.peer
  }
}

resource "aws_cloudwatch_log_group" "my-vpn" {
  name              = "${var.cloudwatch_log_group_name_prefix}${var.endpoint_name}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "my-vpn" {
  log_group_name = aws_cloudwatch_log_group.my-vpn.name
  name           = "connection-log"
}

resource "aws_ec2_client_vpn_endpoint" "my-vpn_sso" {
  description                   = var.endpoint_name
  server_certificate_arn        = var.certificate_arn
  client_cidr_block             = var.endpoint_client_cidr_block
  split_tunnel                  = var.split_tunnel
  transport_protocol            = "udp"
  dns_servers                   = local.dns_servers
  vpn_port                      = var.vpn_port
  security_group_ids            = [aws_security_group.my-vpn.id]
  vpc_id                        = var.vpc_id
  disconnect_on_session_timeout = var.disconnect_on_session_timeout
  session_timeout_hours         = var.session_timeout_hours

  authentication_options {
    type                       = var.saml_provider_arn != "" ? "federated-authentication" : "certificate-authentication"
    saml_provider_arn          = var.saml_provider_arn != "" ? var.saml_provider_arn : null
    root_certificate_chain_arn = var.saml_provider_arn != "" ? null : coalesce(var.client_certificate_arn, var.certificate_arn)
  }
  connection_log_options {
    enabled = false
  }

  tags = merge(var.tags, {
    Name = var.endpoint_name
  })
}

resource "aws_security_group" "my-vpn" {
  name        = "client-vpn-endpoint-${var.endpoint_name}"
  description = "Egress All. Used for other groups where VPN access is required. "
  vpc_id      = var.vpc_id
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  dynamic "ingress" {
    for_each = var.security_group_rule.ingress
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.security_group_rule.egress
    content {
      description = egress.value["description"]
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
    }
  }
  tags = var.tags
}

resource "aws_ec2_client_vpn_network_association" "my-vpn_sso" {
  for_each = toset(var.endpoint_subnets)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "my-vpn_sso_to_dns" {
  for_each = toset(var.authorization_ingress)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  target_network_cidr    = each.value
  authorize_all_groups   = true
  description            = "Authorization for ${var.endpoint_name} to DNS"
}

resource "aws_ec2_client_vpn_route" "my-vpn_sso" {
  for_each = var.additional_routes

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.my-vpn_sso.id
  destination_cidr_block = each.value.cidr
  target_vpc_subnet_id   = each.value.subnet_id
  description            = "From ${each.value.subnet_id} to ${each.value.cidr}"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}
