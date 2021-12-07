provider "aws" {
    region = var.region
}
module "vpc_peering" {
  source     = "dasmeta/modules/aws//modules/aws-vpc-peering"
  for_each   = toset(var.peering_vpc_id)
  providers  = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = var.main_vpc
  peer_vpc_id = each.value

  auto_accept_peering = true

  tags = {
    Name        = "vpc-peering"
    Environment = "Test"
  }
}