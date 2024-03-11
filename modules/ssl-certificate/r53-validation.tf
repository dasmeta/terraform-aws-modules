resource "aws_route53_record" "main" {
  for_each = var.validate == true ? {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      index  = dvo.domain_name
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.validate ? data.aws_route53_zone.zones[local.all_domains[each.value.index].zone].zone_id : null
}
