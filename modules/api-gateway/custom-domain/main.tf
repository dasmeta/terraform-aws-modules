resource "aws_api_gateway_domain_name" "custom_domains" {
  for_each = local.custom_domains_map

  regional_certificate_arn = try(module.certificate_regional[each.key].arn, null)
  certificate_arn          = try(module.certificate_edge[each.key].arn, null)
  domain_name              = each.key

  endpoint_configuration {
    types = [var.endpoint_config_type]
  }
}

resource "aws_api_gateway_base_path_mapping" "custom_domains_api_mapping" {
  for_each = aws_api_gateway_domain_name.custom_domains

  api_id      = var.api_id
  stage_name  = var.stage_name
  domain_name = each.value.domain_name
}
