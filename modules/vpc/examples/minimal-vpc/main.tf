module "minimal-vpc" {
  source = "../../"

  vpc_name = "test-vpc"

  availability_zones  = var.availability_zones
  cidr                = var.cidr
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}
