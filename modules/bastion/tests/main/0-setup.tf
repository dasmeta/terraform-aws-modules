terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "Terraform Automated Testing"
      Owner       = "Git"
      Purpose     = "Terraform Automated Testing"
    }
  }
}
