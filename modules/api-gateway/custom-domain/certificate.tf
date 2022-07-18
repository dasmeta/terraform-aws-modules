module "certificate_regional" {
  source  = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "0.34.0"

  for_each = { for custom_domain in(try(var.custom_domain.name, "") == "" ? [] : [var.custom_domain]) : custom_domain.name => custom_domain if var.endpoint_config_type == "REGIONAL" }

  domain = "${each.value.name}.${each.value.zone_name}"
  zone   = each.value.zone_name
}

module "certificate_edge" {
  source  = "dasmeta/modules/aws//modules/ssl-certificate"
  version = "0.34.0"

  for_each = { for custom_domain in(try(var.custom_domain.name, "") == "" ? [] : [var.custom_domain]) : custom_domain.name => custom_domain if var.endpoint_config_type == "EDGE" }

  domain = "${each.value.name}.${each.value.zone_name}"
  zone   = each.value.zone_name

  providers = {
    aws = aws.virginia
  }
}
