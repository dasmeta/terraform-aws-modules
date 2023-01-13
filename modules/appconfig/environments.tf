resource "aws_appconfig_environment" "main" {
  for_each = { for item in var.environments : item.name => item }

  name           = each.value.name
  description    = each.value.description
  application_id = aws_appconfig_application.main.id

  dynamic "monitor" {
    for_each = toset(each.value.monitors)

    content {
      alarm_arn      = monitor.value.alarm_arn
      alarm_role_arn = monitor.value.alarm_role_arn
    }
  }
}

resource "aws_appconfig_deployment" "main" {
  for_each = { for item in local.deployments : "${item.environment}-${item.config}-${item.version}-${item.strategy}" => item }

  application_id           = aws_appconfig_application.main.id
  configuration_profile_id = aws_appconfig_configuration_profile.main["${each.value.config}-${each.value.version}"].configuration_profile_id
  configuration_version    = aws_appconfig_hosted_configuration_version.main["${each.value.config}-${each.value.version}"].version_number

  deployment_strategy_id = contains([for item in var.deployment_strategies : item.name], each.value.strategy) ? aws_appconfig_deployment_strategy.main[each.value.strategy].id : each.value.strategy
  description            = "env: ${each.value.environment}, config: ${each.value.config}, version: ${each.value.version}, strategy: ${each.value.strategy}"
  environment_id         = aws_appconfig_environment.main[each.value.environment].environment_id

  depends_on = [
    aws_appconfig_hosted_configuration_version.main
  ]
}
