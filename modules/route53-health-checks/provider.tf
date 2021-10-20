provider "aws" {
  alias     = "virginia"
  region = "us-east-1"
}

provider "aws" {
  region = "eu-central-1"
}
