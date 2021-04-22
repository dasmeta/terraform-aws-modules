module "eks-cluster" {
  count = var.create_cluster ? 1 : 0
  providers = {
    helm = helm.eks
  }

  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  # Required parameters
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = var.subnets

  enable_irsa                     = var.enable_irsa
  cluster_endpoint_private_access = true

  worker_groups = var.worker_groups
  workers_group_defaults = var.workers_group_defaults
  worker_groups_launch_template = var.worker_groups_launch_template

  write_kubeconfig   = var.write_kubeconfig
  config_output_path = var.kubeconfig_output_path

  manage_aws_auth = var.manage_aws_auth
  map_users       = var.map_users
}
