provider "aws" {
  region     = "us-east-2"
}
module "vpc-peering" {
  source  = "../aws-vpc-peering"
  count   = var.create_vpc_peering ? 1 : 0
  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = var.main_vpc_id
  peer_vpc_id = var.peering_vpc_id

  auto_accept_peering = true
  tags = var.peering_tags
}
