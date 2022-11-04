module "ssl-certificate-auth" {
  count = var.create_certificate ? 1 : 0

  source              = "dasmeta/modules/aws//modules/ssl-certificate"
  version             = "1.1.2"
  domain              = element(var.aliases, 0)
  alternative_domains = slice(var.aliases, 1, length(var.aliases))
  zone                = element(var.zone, 0)
  alternative_zones   = slice(var.zone, 1, length(var.zone))
  tags                = var.tags
}
