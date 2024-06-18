terraform {
  required_providers {
    # test = {
    #   source = "terraform.io/builtin/test"
    # }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.41"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.3.0"
}

/**
 * set the following env vars so that aws provider will get authenticated before apply:

 export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxxxxxxxxxxxxx
 export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
*/
provider "aws" {
  region = "eu-central-1"
}

data "aws_eks_cluster" "example" {
  name = "eks-dev"
}

data "aws_eks_cluster_auth" "example" {
  name = "eks-dev"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}
