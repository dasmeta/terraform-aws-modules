provider "kubernetes" {
  host                   = var.cluster_host
  cluster_ca_certificate = var.cluster_certificate
  token                  = var.cluster_token
  load_config_file       = false
  # version                = "~> 1.9"
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_host
    cluster_ca_certificate = var.cluster_certificate
    token                  = var.cluster_token
    # load_config_file       = false

    # exec {
    #   api_version = "client.authentication.k8s.io/v1alpha1"
    #   command     = "aws"
    #   args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    # }
  }
}
