provider "kubernetes" {
  host                   = var.cluster.host
  cluster_ca_certificate = var.cluster.certificate
  token                  = var.cluster.token
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.cluster.host
    cluster_ca_certificate = var.cluster.certificate
    token                  = var.cluster.token
  }
}
