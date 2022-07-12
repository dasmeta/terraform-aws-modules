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

resource "aws_cloudwatch_log_group" "access_logs" {
  count = var.enable_access_logs ? 1 : 0

  name = "${var.stage_name}-logs"
}
