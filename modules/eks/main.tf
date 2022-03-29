## Writing kubernetes provider below is a must to avoid
## "configmaps "aws-auth" already exists" error
## See github issue: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/852

data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster[0].cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster[0].cluster_id
}

data "aws_iam_user" "user_arn" {
  for_each  = { for user in var.users : user.username => user }
  user_name = each.value.username
}

locals {
  map_users = flatten([
    for user in var.users : {
      userarn  = data.aws_iam_user.user_arn[user.username].arn
      username = user.username
      groups   = lookup(user, "group", ["system:masters"])
    }
  ])
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  # version                = "~> 1.9"
}

module "eks-cluster" {
  count = var.create_cluster ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  # Required parameters
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = var.subnets // subnet_ids

  enable_irsa                     = var.enable_irsa
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_enabled_log_types       = var.cluster_enabled_log_types

  node_groups                   = var.node_groups            //eks_managed_node_groups
  worker_groups                 = var.worker_groups          //self_managed_node_groups
  workers_group_defaults        = var.workers_group_defaults //self_managed_node_group_defaults
  worker_groups_launch_template = var.worker_groups_launch_template

  write_kubeconfig = var.write_kubeconfig
  # config_output_path = var.kubeconfig_output_path

  # manage_aws_auth = var.manage_aws_auth

  map_users = local.map_users
  map_roles = var.map_roles
}
