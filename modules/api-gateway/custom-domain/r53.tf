resource "aws_route53_record" "this" {
  for_each = aws_api_gateway_domain_name.custom_domain

  name    = each.value.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.custom_domain_zone[each.key].id

  alias {
    evaluate_target_health = true
    name                   = var.endpoint_config_type == "REGIONAL" ? each.value.regional_domain_name : each.value.cloudfront_domain_name
    zone_id                = var.endpoint_config_type == "REGIONAL" ? each.value.regional_zone_id : each.value.cloudfront_zone_id
  }
}
