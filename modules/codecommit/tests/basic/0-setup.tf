terraform {
  required_version = "> 1.5.0, < 2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.0, < 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "> 3.0"
    }
  }
}

/**
 * Uses the same credential locations as the AWS CLI:
 *   - ~/.aws/credentials and ~/.aws/config (see variable aws_profile)
 *   - or environment variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, optional AWS_SESSION_TOKEN
 *
 * Pick a profile explicitly:
 *   terraform apply -var="aws_profile=my-dev-profile" -var="aws_region=us-east-1"
 * or:
 *   export AWS_PROFILE=my-dev-profile
 *   terraform apply -var="aws_region=us-east-1"
 */
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
