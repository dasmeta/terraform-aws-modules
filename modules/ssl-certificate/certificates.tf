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

resource "aws_acm_certificate_validation" "cert" {
  count = var.validate == true ? 1 : 0

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = aws_acm_certificate.main.domain_validation_options[*].resource_record_name
}
