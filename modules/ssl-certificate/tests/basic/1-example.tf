module "basic" {
  source = "../.."
  # version = "2.6.2"

  domain              = "test.dasmeta.com"
  zone                = "test.dasmeta.com"
  alternative_domains = ["*.test.dasmeta.com"]
  alternative_zones   = ["test.dasmeta.com"]
}
