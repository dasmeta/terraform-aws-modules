resource "aws_api_gateway_domain_name" "custom_domain" {
  for_each = { for custom_domain in(try(var.custom_domain.name, "") == "" ? [] : [var.custom_domain]) : custom_domain.name => custom_domain }

  regional_certificate_arn = try(module.certificate_regional[each.key].arn, null)
  certificate_arn          = try(module.certificate_edge[each.key].arn, null)
  domain_name              = "${each.value.name}.${each.value.zone_name}"

  endpoint_configuration {
    types = [var.endpoint_config_type]
  }
}

resource "aws_api_gateway_base_path_mapping" "custom_domain_api_mapping" {
  for_each = aws_api_gateway_domain_name.custom_domain

  api_id      = var.api_id
  stage_name  = var.stage_name
  domain_name = each.value.domain_name
}
