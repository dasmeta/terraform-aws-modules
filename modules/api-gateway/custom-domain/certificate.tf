module "certificate_regional" {
  source  = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "0.34.0"

  for_each = { for key, custom_domain in local.custom_domains_map : key => custom_domain if var.endpoint_config_type == "REGIONAL" }

  domain = each.key
  zone   = each.value.zone_name
}

module "certificate_edge" {
  source  = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "0.34.0"

  for_each = { for key, custom_domain in local.custom_domains_map : key => custom_domain if var.endpoint_config_type == "EDGE" }

  domain = each.key
  zone   = each.value.zone_name

  providers = {
    aws = aws.virginia
  }
}
