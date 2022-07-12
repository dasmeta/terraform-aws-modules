resource "aws_api_gateway_rest_api" "api-gateway" {
  name = var.name

  endpoint_configuration {
    types = [var.endpoint_config_type]
  }
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  resource_id   = aws_api_gateway_rest_api.api-gateway.root_resource_id
  http_method   = var.method_values.http_method
  authorization = var.method_values.authorization

  request_parameters = var.method_values.request_parameters

  api_key_required = var.method_values.api_key_required
}

resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_rest_api.api-gateway.root_resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "aws_api_integr" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_rest_api.api-gateway.root_resource_id
  http_method = aws_api_gateway_method.api_method.http_method

  type                    = var.integration_values.type
  uri                     = var.integration_values.endpoint_uri
  integration_http_method = var.integration_values.integration_http_method

  request_parameters = var.integration_values.request_parameters
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_rest_api.api-gateway.root_resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.method_response.status_code
}

resource "aws_api_gateway_stage" "aws-api-stage" {
  stage_name = var.stage_name

  deployment_id = aws_api_gateway_deployment.aws-api-depl.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id

  dynamic "access_log_settings" {
    for_each = aws_cloudwatch_log_group.access_logs

    content {
      destination_arn = access_log_settings.value.arn
      format          = var.access_logs_format
    }
  }
}

# This is region wide setting and can be set once, if you have already set account setting no need for second one to have
module "account_settings" {
  source = "../api-gateway-account-settings" # TODO: please set registry path instead relative folder

  count = var.set_account_settings ? 1 : 0
}

resource "aws_api_gateway_deployment" "aws-api-depl" {
  rest_api_id = var.rest_api_id != "" ? var.rest_api_id : aws_api_gateway_rest_api.api-gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api-gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.aws_api_integr,
    aws_api_gateway_method.api_method
  ]
}

resource "aws_api_gateway_usage_plan" "example" {
  name        = var.usage_plan_values.usage_plan_name
  description = var.usage_plan_values.usage_plan_description

  api_stages {
    api_id = aws_api_gateway_rest_api.api-gateway.id
    stage  = aws_api_gateway_stage.aws-api-stage.stage_name
  }

  quota_settings {
    limit  = var.usage_plan_values.quota_limit
    period = var.usage_plan_values.quota_period
  }

  throttle_settings {
    burst_limit = var.usage_plan_values.throttle_burst_limit
    rate_limit  = var.usage_plan_values.throttle_rate_limit
  }
}

resource "aws_api_gateway_method_settings" "general_settings" {
  count = var.enable_monitoring ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  stage_name  = var.stage_name
  method_path = var.method_path

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled    = var.monitoring_settings.metrics_enabled
    data_trace_enabled = var.monitoring_settings.data_trace_enabled
    logging_level      = var.monitoring_settings.logging_level

    # Limit the rate of calls to prevent abuse and unwanted charges
    throttling_rate_limit  = var.monitoring_settings.throttling_rate_limit
    throttling_burst_limit = var.monitoring_settings.throttling_burst_limit
  }

  depends_on = [module.account_settings] # if you get the error "CloudWatch Logs role ARN must be set in account settings to enable logging" please set set_account_settings to true 
}

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

  api_id      = aws_api_gateway_rest_api.api-gateway.id
  stage_name  = aws_api_gateway_stage.aws-api-stage.stage_name
  domain_name = each.value.domain_name
}
