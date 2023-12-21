terraform {
  required_providers {
    # test = {
    #   source = "terraform.io/builtin/test"
    # }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
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
  region = "us-east-1"
}

data "aws_eks_cluster" "example" {
  name = "test-eks-spot-instances"
}

data "aws_eks_cluster_auth" "example" {
  name = "test-eks-spot-instances"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.example.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.example.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.example.token
}
