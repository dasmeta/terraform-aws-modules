provider "aws" {
    access_key = ""
    secret_key = ""
    profile = "default"
    region = "us-east-2"
}

module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.2"
  for_each = { for x in var.repo : x => x }
  name  = "${each.value}"
}
