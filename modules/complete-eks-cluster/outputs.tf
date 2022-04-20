### CLUSTER
output "oidc_provider_arn" {
  value = module.eks-cluster.oidc_provider_arn
}

output "eks_oidc_root_ca_thumbprint" {
  value       = local.eks_oidc_root_ca_thumbprint
  description = "Grab eks_oidc_root_ca_thumbprint from oidc_provider_arn."
}

output "cluster_id" {
  value = module.eks-cluster.cluster_id
}

output "kubeconfig_filename" {
  value = module.eks-cluster.kubeconfig_filename
}

output "cluster_iam_role_name" {
  value = module.eks-cluster.cluster_iam_role_name
}

output "worker_iam_role_name" {
  value = module.eks-cluster.worker_iam_role_name
}

output "cluster_security_group_id" {
  value = module.eks-cluster.cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  value = module.eks-cluster.cluster_primary_security_group_id
}

output "map_user_data" {
  value = module.eks-cluster.map_users_data
}
# output "cluster_name" {
#   value = module.eks-cluster.cluster_name
# }

### VPC
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "cluster_host" {
  value = module.eks-cluster.host
}

output "cluster_certificate" {
  value = module.eks-cluster.certificate
}

output "cluster_token" {
  value = module.eks-cluster.token
}
