locals {
  eks_oidc_root_ca_thumbprint = replace(module.eks-cluster.oidc_provider_arn, "/.*id//", "")
}

module "vpc_this" {
  source    = "../vpc" # change to the correct one

  vpc_name            = var.vpc_name
  availability_zones  = var.availability_zones
  cidr                = var.cidr
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
}

module "eks-cluster" {
  source = "../eks" # change to the correct one.

  cluster_name  = var.cluster_name
  vpc_id        = module.vpc_this.vpc_id
  subnets       = module.vpc_this.vpc_private_subnets
  depends_on    = [module.vpc_this]
}

module "cloudwatch-metrics" {
  # source = "git::https://github.com/dasmeta/terraform.git"
  source = "../aws-cloudwatch-metrics" # change to the correct one.

  eks_oidc_root_ca_thumbprint = local.eks_oidc_root_ca_thumbprint
  oidc_provider_arn = module.eks-cluster.oidc_provider_arn
  cluster_name = var.cluster_name
}

module "alb-ingress-controller" {
  # source = "git::https://github.com/dasmeta/terraform.git"
  source = "../aws-load-balancer-controller" # change to the correct one.

  cluster_name = var.cluster_name
  eks_oidc_root_ca_thumbprint = local.eks_oidc_root_ca_thumbprint
  oidc_provider_arn = module.eks-cluster.oidc_provider_arn
  create_alb_log_bucket = true
  alb_log_bucket_prefix = "${var.cluster_name}-ingress-controller-log-bucket"
}
