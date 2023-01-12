module "security-group-ssh" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "bastion-ssh"
  description = "Security group for bastion to ssh"
  vpc_id      = data.aws_vpcs.all.ids[0]

  ingress_cidr_blocks = [data.aws_vpc.default.cidr_block, "0.0.0.0/0"]
}
