module "this" {
  source = "../.."

  validate_in_aws = false
  domain          = "*.dasmeta.com"
}
