module "this" {
  source = "../.."

  domain              = "dasmeta.com"
  alternative_domains = ["*.dasmeta.com"]
  alternative_zones   = ["dasmeta.com"]
  zone                = "dasmeta.com"
}
