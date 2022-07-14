data "aws_route53_zone" "custom_domain_zone" {
  for_each = { for custom_domain in(try(var.custom_domain.name, "") == "" ? [] : [var.custom_domain]) : custom_domain.name => custom_domain }

  name = each.value.zone_name
}
