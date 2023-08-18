module "this" {
  source = "../.."

  validate            = false
  domain              = "*.devops.dasmeta.com"
  alternative_domains = ["dm.example.io"]
}
