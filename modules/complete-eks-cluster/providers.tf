terraform {
  required_version = ">= 0.14.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.31"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}
