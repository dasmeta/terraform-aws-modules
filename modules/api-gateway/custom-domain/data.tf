data "aws_route53_zone" "custom_domain_zones" {
  for_each = local.custom_domains_map

  name = each.value.zone_name
}
