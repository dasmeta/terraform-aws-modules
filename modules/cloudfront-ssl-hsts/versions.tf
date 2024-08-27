terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 3.64, < 6.0"
      configuration_aliases = [aws.virginia]
    }
  }
}
