# This is region wide setting required for enabling cloudwatch logging and can be set once, if you have already set account setting no need for second one to have
module "account_settings" {
  source = "../api-gateway-account-settings" # TODO: please set registry path instead relative folder

  count = var.set_account_settings ? 1 : 0
}

# general
resource "aws_api_gateway_rest_api" "this" {
  name = var.name
  body = var.body

  endpoint_configuration {
    types = [var.endpoint_config_type]
  }
}

# root resource methods configs
resource "aws_api_gateway_method" "root_methods" {
  for_each = var.root_resource_configs

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id

  http_method        = each.key
  authorization      = try(each.value.authorization, "NONE")
  request_parameters = try(each.value.request_parameters, {})
  api_key_required   = try(each.value.api_key_required, true)
}

resource "aws_api_gateway_method_response" "root_methods_responses" {
  for_each = var.root_resource_configs

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id

  http_method     = each.key
  response_models = try(each.value.response.models, null)
  status_code     = try(each.value.response.status_code, "200")
}

resource "aws_api_gateway_integration" "root_methods_integrations" {
  for_each = var.root_resource_configs

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id

  http_method             = each.key
  type                    = try(each.value.integration.type, "HTTP")
  uri                     = try(each.value.integration.endpoint_uri, "https://www.google.de")
  integration_http_method = try(each.value.integration.integration_http_method, null)
  request_parameters      = try(each.value.integration.request_parameters, {})
}

resource "aws_api_gateway_integration_response" "root_methods_integration_responses" {
  for_each = var.root_resource_configs

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_rest_api.this.root_resource_id

  http_method = each.key
  status_code = aws_api_gateway_method_response.root_methods_responses[each.key].status_code
}

resource "aws_api_gateway_stage" "stage" {
  stage_name = var.stage_name

  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.this.id

  dynamic "access_log_settings" {
    for_each = aws_cloudwatch_log_group.access_logs

    content {
      destination_arn = access_log_settings.value.arn
      format          = var.access_logs_format
    }
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.root_methods,
    aws_api_gateway_integration.root_methods_integrations
  ]
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  count = try(var.usage_plan_values.usage_plan_name, "") != "" ? 1 : 0

  name        = var.usage_plan_values.usage_plan_name
  description = var.usage_plan_values.usage_plan_description

  api_stages {
    api_id = aws_api_gateway_rest_api.this.id
    stage  = aws_api_gateway_stage.stage.stage_name
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

  rest_api_id = aws_api_gateway_rest_api.this.id
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

module "custom_domain" {
  source = "./custom-domain"

  api_id        = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
  custom_domain = var.custom_domain

  providers = {
    aws.virginia = aws.virginia
  }
}
