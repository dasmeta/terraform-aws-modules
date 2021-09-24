provider "helm" {
  kubernetes {
    host                   = var.cluster_host
    cluster_ca_certificate = var.cluster_certificate
    token                  = var.cluster_token
  }
}
