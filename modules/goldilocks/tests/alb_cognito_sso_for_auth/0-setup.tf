terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("~/.kube/config")
  }
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}
