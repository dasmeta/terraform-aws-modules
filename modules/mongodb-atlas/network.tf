data "aws_vpc" "peering_vpcs" {
  for_each = { for peer in var.network_peering : "${var.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

  id = each.value.vpc_id
}

data "aws_route_table" "peering_vpcs_route_tables" {
  for_each = { for peer in var.network_peering : "${var.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

  vpc_id    = each.value.vpc_id
  subnet_id = each.value.subnet_id
}

resource "mongodbatlas_project_ip_access_list" "ip-access-list" {
  for_each = toset(var.ip_addresses)

  project_id = mongodbatlas_project.main.id
  ip_address = each.value
  comment    = "terraform set ${each.value} IP(range) whitelist"
}

resource "mongodbatlas_project_ip_access_list" "vpc_cidr_whitelist" {
  for_each = data.aws_vpc.peering_vpcs

  project_id = mongodbatlas_project.main.id
  cidr_block = each.value.cidr_block # TODO: there is option to set aws_security_group instead of cidr_block, please check to pick the most correct one
  comment    = "terraform set ${each.value.id} VPC ${each.value.cidr_block} CIDR whitelist"
}

resource "mongodbatlas_network_peering" "mongo_peers" {
  for_each = { for peer in var.network_peering : "${var.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

  # mongo atlas side options
  accepter_region_name   = each.value.accepter_region_name
  route_table_cidr_block = data.aws_vpc.peering_vpcs[each.key].cidr_block
  vpc_id                 = each.value.vpc_id
  aws_account_id         = each.value.aws_account_id

  # this option is configurable but this resource actually hardcoded for only AWS provider
  # TODO: it is most possible we will need this module for other providers (GCP and AZURE), so there can be need to refactor it a bit and move to common(not specific provider owned) terraform modules repo/registry
  provider_name = var.provider_name

  # aws provider side options
  project_id       = mongodbatlas_project.main.id
  container_id     = mongodbatlas_cluster.main.container_id
  atlas_cidr_block = each.value.atlas_cidr_block
}

resource "aws_vpc_peering_connection_accepter" "aws_peers" {
  for_each = { for peer in var.network_peering : "${var.provider_name}-${peer.accepter_region_name}-${peer.vpc_id}" => peer }

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

resource "aws_route" "mongo_route_record" {
  for_each = data.aws_vpc.peering_vpcs

  route_table_id            = data.aws_route_table.peering_vpcs_route_tables[each.key].route_table_id
  destination_cidr_block    = mongodbatlas_network_peering.mongo_peers[each.key].atlas_cidr_block
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peers[each.key].connection_id
}
