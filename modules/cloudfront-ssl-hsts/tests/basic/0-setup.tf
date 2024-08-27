terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

locals {
  domain = "basic-test-cloudfront.devops.dasmeta.com"
  zone   = "devops.dasmeta.com"
}

resource "aws_s3_bucket" "this" {
  bucket = local.domain
}
