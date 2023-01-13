resource "aws_appconfig_deployment_strategy" "main" {
  for_each = { for item in var.deployment_strategies : item.name => item }

  name                           = each.value.name
  description                    = each.value.description
  deployment_duration_in_minutes = each.value.deployment_duration_in_minutes
  final_bake_time_in_minutes     = each.value.final_bake_time_in_minutes
  growth_factor                  = each.value.growth_factor
  growth_type                    = each.value.growth_type
  replicate_to                   = each.value.replicate_to
}
