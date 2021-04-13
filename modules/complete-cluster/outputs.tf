output "oidc_provider_arn" {
  value = module.eks-cluster.oidc_provider_arn
}

output "eks_oidc_root_ca_thumbprint" {
  value = local.eks_oidc_root_ca_thumbprint
  description = "Grab eks_oidc_root_ca_thumbprint from oidc_provider_arn."
}
