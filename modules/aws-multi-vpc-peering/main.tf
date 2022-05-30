module "vpc_peering" {
  source = "../aws-vpc-peering"

  for_each = toset(var.peering_vpc_id)

  providers = {
    aws.this = aws
    aws.peer = aws.peer
  }

  this_vpc_id = var.main_vpc
  peer_vpc_id = each.value

  auto_accept_peering = true

  tags = {
    Name = "vpc-peering-${replace(each.value, "/[^0-9a-z]/i", "-")}"
  }
}
