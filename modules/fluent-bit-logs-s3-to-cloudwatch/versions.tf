terraform {
  required_providers {
    helm = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = "~> 1.0"
}
