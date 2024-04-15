locals {
  default_ingress_rule = [
    {
      description = "EFS to VPC"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = data.aws_vpc.selected[0].cidr_block
    }
  ]
  default_egress_rule = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]
  combined_egress_rules = concat(
    local.default_egress_rule,
    var.ingress_with_cidr_blocks
  )
  combined_ingress_rules = concat(
    local.default_ingress_rule,
    var.egress_with_cidr_blocks
  )
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name        = var.security_group_name != "" ? var.security_group_name : "${var.name}"
  description = var.security_group_description != "" ? var.security_group_description : "Allow EFS traffic to VPC"
  vpc_id      = data.aws_vpc.selected[0].id

  # ingress
  ingress_with_cidr_blocks = local.combined_ingress_rules
  egress_with_cidr_blocks  = local.combined_egress_rules

  tags = {
    Source = "efs-to-vpc"
  }
}
