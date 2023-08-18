module "this" {
  source = "../.."

  domain              = "dasmeta.com"
  alternative_domains = ["*.dasmeta.com", "*.a.dasmeta.com", "b.dasmeta.com"]
  alternative_zones   = ["dasmeta.com", "a.dasmeta.com", "b.dasmeta.com"]
  zone                = "dasmeta.com"
}
