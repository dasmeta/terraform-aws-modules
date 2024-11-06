locals {
  dkim_record_0 = {
    name : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[0]}._domainkey.${var.email_domain}."
    record : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[0]}.dkim.amazonses.com."
    type : "CNAME"
  }
  dkim_record_1 = {
    name : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[1]}._domainkey.${var.email_domain}."
    record : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[1]}.dkim.amazonses.com."
    type : "CNAME"
  }
  dkim_record_2 = {
    name : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[2]}._domainkey.${var.email_domain}."
    record : "${aws_ses_domain_dkim.ses_domain.dkim_tokens[2]}.dkim.amazonses.com."
    type : "CNAME"
  }

  region = var.region == null ? data.aws_region.current.name : var.region
}

data "aws_route53_zone" "this" {
  count = anytrue([var.create_spf_route53, var.create_dkim_route53]) ? 1 : 0
  name  = var.email_domain
}
