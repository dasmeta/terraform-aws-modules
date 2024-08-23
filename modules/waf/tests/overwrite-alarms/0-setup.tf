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
resource "aws_lb" "test1" {
  name     = "test-waf-alb-association-1"
  provider = aws
  subnets  = data.aws_subnets.default.ids
}

# create test alb
resource "aws_lb" "test2" {
  name     = "test-waf-alb-association-2"
  provider = aws
  subnets  = data.aws_subnets.default.ids
}
