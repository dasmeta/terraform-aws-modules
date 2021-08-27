resource "mongodbatlas_project_ip_access_list" "ip-access-list" {
  for_each = toset(var.ip_addresses)

  project_id = mongodbatlas_project.main.id
  ip_address = each.value
  comment    = "ip address range items"
}

resource "mongodbatlas_network_peering" "mongo_peer" {
  accepter_region_name   = "eu-central-1"
  project_id             = mongodbatlas_project.main.id
  container_id           = mongodbatlas_cluster.main.container_id
  provider_name          = "AWS"
  route_table_cidr_block = var.route_table_cidr_block
  vpc_id                 = var.vpc_id
  aws_account_id         = var.aws_account_id
}

resource "aws_vpc_peering_connection_accepter" "aws_peer" {
  vpc_peering_connection_id = mongodbatlas_network_peering.mongo_peer.connection_id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
