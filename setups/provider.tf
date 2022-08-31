terraform {
  required_version = ">= 0.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.26.0"
    }
  }
}
provider "aws" {
  region = "eu-west-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}