data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

locals {
  # used for iam role principals
  cluster_identity_oidc_issuer     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  cluster_identity_oidc_issuer_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.cluster_identity_oidc_issuer}"
}
