data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster[0].cluster_id
}

data "aws_iam_user" "user_arn" {
  for_each  = { for user in var.users : user.username => user }
  user_name = each.value.username
}

module "eks-cluster" {
  count = var.create_cluster ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  # per Upgrade from v17.x to v18.x, see here for details https://github.com/terraform-aws-modules/terraform-aws-eks/blob/681e00aafea093be72ec06ada3825a23a181b1c5/docs/UPGRADE-18.0.md
  prefix_separator                   = ""
  iam_role_name                      = var.cluster_name
  cluster_security_group_name        = var.cluster_name
  cluster_security_group_description = "EKS cluster security group."

  # Required parameters
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnets

  enable_irsa                     = var.enable_irsa
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_enabled_log_types       = var.cluster_enabled_log_types

  eks_managed_node_groups          = var.node_groups
  self_managed_node_groups         = var.worker_groups
  self_managed_node_group_defaults = var.workers_group_defaults

  aws_auth_users = local.map_users
  aws_auth_roles = var.map_roles
}
