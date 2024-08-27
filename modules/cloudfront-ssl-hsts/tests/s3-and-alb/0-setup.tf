terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
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
  domain = "s3-and-alb-test-cloudfront.devops.dasmeta.com"
  zone   = "devops.dasmeta.com"
}

resource "aws_s3_bucket" "test" {
  bucket = local.domain
}

# get region default vpc and its public subnets
data "aws_vpc" "default" {
  default  = true
  provider = aws
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# create test alb
resource "aws_lb" "test" {
  name     = "cloudfront-test-alb"
  provider = aws
  subnets  = data.aws_subnets.default.ids
}
