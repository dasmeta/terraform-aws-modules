module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  count                = var.create_vpc ? 1 : 0
  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = var.availability_zones
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  # public_subnet_tags = {
  #   "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  #   "kubernetes.io/role/elb"                      = "1"
  # }

  # private_subnet_tags = {
  #   "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  #   "kubernetes.io/role/internal-elb"             = "1"
  # }
}
