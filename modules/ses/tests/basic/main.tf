module "ses" {
  source           = "../../"
  email_domain     = "devops.dasmeta.com"
  mail_users       = ["prod"]
  verified_domains = ["devops.dasmeta.com"]
}
