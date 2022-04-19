output "cluster_id" {
  value = module.eks-cluster[0].cluster_id
}

# output "cluster_name" {
#   value = module.eks-cluster[0].cluster_name
# }

output "kubeconfig_filename" {
  # value = module.eks-cluster[0].local_file.kubeconfig[0].kubeconfig_filename
  value = module.eks-cluster[0].kubeconfig_filename
}

output "cluster_iam_role_name" {
  value = module.eks-cluster[0].cluster_iam_role_name
}

output "worker_iam_role_name" {
  value = module.eks-cluster[0].worker_iam_role_name
}

output "eks_oidc_root_ca_thumbprint" {
  value       = local.eks_oidc_root_ca_thumbprint
  description = "Grab eks_oidc_root_ca_thumbprint from oidc_provider_arn."
}

output "oidc_provider_arn" {
  value = module.eks-cluster[0].oidc_provider_arn
}

output "cluster_security_group_id" {
  value = module.eks-cluster[0].cluster_security_group_id
}

output "cluster_primary_security_group_id" {
  value = module.eks-cluster[0].cluster_primary_security_group_id
}

output "host" {
  value = module.eks-cluster[0].cluster_endpoint
}

output "certificate" {
  value = base64decode(module.eks-cluster[0].cluster_certificate_authority_data)
}

output "token" {
  value = data.aws_eks_cluster_auth.cluster.token
}
output "map_users_data" {
  value = local.map_users
}
