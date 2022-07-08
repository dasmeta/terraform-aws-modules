terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  host                   = var.cluster_host
  cluster_ca_certificate = var.cluster_certificate
  token                  = var.cluster_token
}

provider "kubectl" {
  host                   = var.cluster_host
  cluster_ca_certificate = var.cluster_certificate
  token                  = var.cluster_token
  load_config_file       = false
}
