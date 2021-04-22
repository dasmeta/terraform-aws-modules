module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3"

  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  tags = var.tags
}
