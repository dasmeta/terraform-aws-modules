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

  request_parameters = {
    "method.request.header.x-api-key" = var.method_values.api_key_required
  }

  api_key_required = true
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

  request_parameters = {
    "${var.integration_values.header_name}" = var.integration_values.header_mapto
  }
}

resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api-gateway.id
  resource_id = aws_api_gateway_rest_api.api-gateway.root_resource_id
  http_method = aws_api_gateway_method.api_method.http_method
  status_code = aws_api_gateway_method_response.method_response.status_code
}

resource "aws_api_gateway_stage" "aws-api-stage" {
  deployment_id = aws_api_gateway_deployment.aws-api-depl.id
  rest_api_id   = aws_api_gateway_rest_api.api-gateway.id
  stage_name    = var.stage_name
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
}
