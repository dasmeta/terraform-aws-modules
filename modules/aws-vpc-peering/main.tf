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
  count                     = var.create_vpc_peering ? 1 : 0
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer_accepter.id

  accepter {
    allow_remote_vpc_dns_resolution  = var.peer_dns_resolution
    allow_classic_link_to_remote_vpc = var.peer_link_to_peer_classic
    allow_vpc_to_remote_classic_link = var.peer_link_to_local_classic
  }
}

resource "aws_route" "this_routes" {
  provider                  = aws.this
  count                     = var.from_this ? length(local.this_routes) : 0
  route_table_id            = local.this_routes[count.index].rts_id
  destination_cidr_block    = local.this_routes[count.index].dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
resource "aws_route" "peer_routes" {
  provider                  = aws.peer
  count                     = var.from_peer ? length(local.peer_routes) : 0
  route_table_id            = local.peer_routes[count.index].rts_id
  destination_cidr_block    = local.peer_routes[count.index].dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
