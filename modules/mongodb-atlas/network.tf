resource "mongodbatlas_project_ip_access_list" "ip-access-list" {
  for_each = toset(var.ip_addresses)

  project_id = mongodbatlas_project.main.id
  ip_address = each.value
  comment    = "ip address range items"
}

resource "mongodbatlas_network_peering" "mongo_peers" {
  for_each = { for peer in var.network_peering : "${peer.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

  accepter_region_name   = each.value.accepter_region_name
  project_id             = mongodbatlas_project.main.id
  container_id           = mongodbatlas_cluster.main.container_id
  provider_name          = each.value.provider_name
  route_table_cidr_block = each.value.route_table_cidr_block
  vpc_id                 = each.value.vpc_id
  aws_account_id         = each.value.aws_account_id
}

resource "aws_vpc_peering_connection_accepter" "aws_peers" {
  for_each = { for peer in var.network_peering : "${peer.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peers[each.key].connection_id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }

  accepter {
    allow_classic_link_to_remote_vpc = false
    allow_remote_vpc_dns_resolution  = false
    allow_vpc_to_remote_classic_link = false
  }
}
