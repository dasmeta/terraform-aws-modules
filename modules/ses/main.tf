resource "aws_ses_email_identity" "verified_email" {
  for_each = { for value in var.verified_email_users : value => value }
  email    = each.value
}

resource "aws_ses_domain_identity" "verified_domains" {
  for_each = { for value in var.verified_domains : value => value }
  domain   = each.value
}

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.email_domain
}

resource "aws_ses_domain_dkim" "ses_domain" {
  domain = var.email_domain
}

resource "aws_route53_record" "spf" {
  count   = var.create_spf_route53 ? 1 : 0
  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = ""
  type    = "TXT"
  records = ["v=spf1 include:amazonses.com ~all"]
  ttl     = 600
}

resource "aws_route53_record" "dkim" {
  count   = var.create_dkim_route53 ? 3 : 0
  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain.dkim_tokens, count.index)}._domainkey.${var.email_domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${element(aws_ses_domain_dkim.ses_domain.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
