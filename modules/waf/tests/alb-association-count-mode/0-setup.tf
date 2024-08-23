terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
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
  name     = "test-waf-alb-association-cm"
  provider = aws
  subnets  = data.aws_subnets.default.ids
}
