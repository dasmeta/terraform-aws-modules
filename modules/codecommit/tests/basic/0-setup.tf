terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

/**
 * Authentication and region use the AWS default chain (same as the AWS CLI):
 *   - export AWS_PROFILE=... and/or AWS_REGION=...
 *   - or ~/.aws/credentials and ~/.aws/config
 *   - or AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY (and optional AWS_SESSION_TOKEN)
 */
provider "aws" {}
