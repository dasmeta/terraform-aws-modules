terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }

  }

  required_version = ">= 1.3.0"
}

# set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY variable for aws provider setup
provider "aws" {
  region = "eu-central-1"
}
