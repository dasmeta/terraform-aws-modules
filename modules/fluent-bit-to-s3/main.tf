/**
 * # Why
 * Terraform module to export container logs from EKS to S3
 *
 * ## Example
 * ```
 * module "fluent-bit" {
 *   source = "../fluent-bit-to-s3"
 *
 *   fluent_bit_name             = "fluent-bit"
 *   bucket_name                 = "fluent-bit-cloudwatch-354242324"
 *   cluster_name                = ""
 *   eks_oidc_root_ca_thumbprint = module.eks-cluster.eks_oidc_root_ca_thumbprint
 *   oidc_provider_arn           = module.eks-cluster.oidc_provider_arn
 *
 *   cluster_host        = module.eks-cluster.host
 *   cluster_certificate = module.eks-cluster.certificate
 *   cluster_token       = module.eks-cluster.token
 *   region              = data.aws_region.current.name
 * }
 * ```
 */
