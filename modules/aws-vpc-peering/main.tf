##########################
# VPC peering connection #
##########################

resource "aws_vpc_peering_connection" "this" {
  provider      = aws.this
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.this_vpc_id
  peer_region   = data.aws_region.peer.name
  tags          = merge(var.tags, tomap({ "Side" = local.same_acount_and_region ? "Both" : "Requester" }))
  # hardcoded
  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = var.auto_accept_peering
  tags                      = merge(var.tags, tomap({ "Side" = local.same_acount_and_region ? "Both" : "Accepter" }))
}

resource "aws_vpc_peering_connection_options" "this" {
  provider                  = aws.this
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  requester {
    allow_remote_vpc_dns_resolution  = var.this_dns_resolution
    allow_classic_link_to_remote_vpc = var.this_link_to_peer_classic
    allow_vpc_to_remote_classic_link = var.this_link_to_local_classic
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  count = var.create_vpc_peering ? 1 : 0

  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  accepter {
    allow_remote_vpc_dns_resolution  = var.peer_dns_resolution
    allow_classic_link_to_remote_vpc = var.peer_link_to_peer_classic
    allow_vpc_to_remote_classic_link = var.peer_link_to_local_classic
  }
}

resource "aws_route" "this_routes" {
  for_each = var.from_this ? { for this_route in local.this_routes : "${this_route.rts_id}--${this_route.dest_cidr}" => this_route } : {}

  route_table_id            = each.value.rts_id
  destination_cidr_block    = each.value.dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  provider = aws.this
}

resource "aws_route" "peer_routes" {
  for_each = var.from_peer ? { for peer_route in local.peer_routes : "${peer_route.rts_id}--${peer_route.dest_cidr}" => peer_route } : {}

  route_table_id            = each.value.rts_id
  destination_cidr_block    = each.value.dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  provider = aws.peer
}
