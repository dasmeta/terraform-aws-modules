module "ses" {
  source           = "../../"
  email_domain     = "devops.dasmeta.com"
  mail_users       = ["prod"]
  verified_domains = ["devops.dasmeta.com"]
}

module "ses-virginia" {
  source           = "../../"
  email_domain     = "devops.dasmeta.com"
  mail_users       = ["prod-virginia"]
  verified_domains = ["devops.dasmeta.com"]
  region           = "us-east-1"
  prefix           = "virginia"

  providers = {
    aws = aws.virginia # Explicitly pass the AWS provider
  }
}


provider "aws" {
  region = "us-east-1" # Specify the desired AWS region here
  alias  = "virginia"
}
