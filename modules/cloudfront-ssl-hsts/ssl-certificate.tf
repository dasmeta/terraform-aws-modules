module ssl-certificate-auth {
  source = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "0.17.1"
  count = var.create_certificate ? 1 : 0
  domain              = element(var.aliases, 0)
  alternative_domains = slice (var.aliases,1,length(var.aliases))
  zone                = element(var.zone, 0)
  alternative_zone    = slice (var.zone,1,length(var.zone))
  tags = var.tags
}
