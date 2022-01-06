locals {

  domains_union = concat([var.zone], var.alternative_zones)
  all_zones = { for index, zone in toset(local.domains_union) :
    zone => zone
  }

  all_domains = { for index, domain in concat([var.domain], var.alternative_domains) :
    domain => {
      domain = domain
      zone   = local.domains_union[index]
    }
  }
}
resource "aws_acm_certificate" "main" {
  domain_name               = var.domain
  subject_alternative_names = var.alternative_domains
  validation_method         = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
data "aws_route53_zone" "zones" {
  for_each = local.all_zones

  name         = each.value
  private_zone = false
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = aws_acm_certificate.main.domain_validation_options[*].resource_record_name

  depends_on = [
    aws_route53_record.main
  ]
}

resource "aws_route53_record" "main" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
      index  = dvo.domain_name
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zones[local.all_domains[each.value.index].zone].zone_id
}