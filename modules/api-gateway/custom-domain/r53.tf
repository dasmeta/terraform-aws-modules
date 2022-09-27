resource "aws_route53_record" "this" {
  for_each = { for item in local.r53_records : item.key => item }

  name           = each.value.name
  type           = "A"
  zone_id        = data.aws_route53_zone.custom_domain_zones["${each.value.name}.${each.value.zone_name}"].id
  set_identifier = try(each.value.set_identifier, null)

  alias {
    evaluate_target_health = true
    name                   = var.endpoint_config_type == "REGIONAL" ? aws_api_gateway_domain_name.custom_domains["${each.value.name}.${each.value.zone_name}"].regional_domain_name : each.value.cloudfront_domain_name
    zone_id                = var.endpoint_config_type == "REGIONAL" ? aws_api_gateway_domain_name.custom_domains["${each.value.name}.${each.value.zone_name}"].regional_zone_id : each.value.cloudfront_zone_id
  }

  dynamic "geolocation_routing_policy" {
    for_each = length(keys(try(each.value.geolocation_routing_policy, {}))) == 0 ? [] : [true]

    content {
      continent   = lookup(each.value.geolocation_routing_policy, "continent", null)
      country     = lookup(each.value.geolocation_routing_policy, "country", null)
      subdivision = lookup(each.value.geolocation_routing_policy, "subdivision", null)
    }
  }
}
