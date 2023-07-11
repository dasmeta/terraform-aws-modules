terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
