variable "name" {
  type        = string
  description = "The name of API gateway"
}

variable "body" {
  type        = string
  default     = null
  description = "An OpenAPI/Sagger specification json string with description of paths/resources/methods, check AWS docs for more info: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html"
}

variable "endpoint_config_type" {
  type        = string
  default     = "REGIONAL"
  description = "API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE"
}

variable "root_resource_configs" {
  type = any
  default = {
    POST = {
      authorization      = "NONE"
      api_key_required   = true
      request_parameters = {}
      response = {
        models      = null
        status_code = "200"
      }
      integration = {
        type                    = "HTTP" #HTTP AWS MOCK HTTP_PROXY AWS_PROXY
        endpoint_uri            = "https://www.google.de"
        integration_http_method = null
        request_parameters      = { "integration.request.header.x-api-key" = "method.request.header.x-api-key" }
      }
    }

  }
  description = "The methods/methods_responses/integrations configs for root '/' resource, the key is HTTPS method like ANY/POST/GET"
}

variable "create_iam_user" {
  type        = bool
  default     = true
  description = "Whether to create specific api access user to api gateway./[''871]."
}

variable "pgp_key" {
  description = "Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true`"
  type        = string
  default     = null
}

variable "stage_name" {
  type    = string
  default = "api-stage"
}

variable "enable_access_logs" {
  type        = bool
  default     = true
  description = "Weather enable or not the access logs on stage"
}

variable "access_logs_format" {
  type        = string
  default     = <<EOT
{ "requestId":"$context.requestId", "resourcePath":"$context.resourcePath", "httpMethod":"$context.httpMethod", "responseLength":"$context.responseLength", "responseLatency":"$context.responseLatency", "status":"$context.status", "protocol":"$context.protocol", "extendedRequestId":"$context.extendedRequestId", "ip": "$context.identity.sourceIp", "caller":"$context.identity.caller", "user":"$context.identity.user", "userAgent":"$context.identity.userAgent", "requestTime":"$context.requestTime"}
EOT
  description = "The access logs format to sync into cloudwatch log group"
}

variable "usage_plan_values" {
  type = any
  default = {
    usage_plan_name        = "my-usage-plan"
    usage_plan_description = "my description"
    quota_limit            = 10000
    quota_period           = "MONTH"
    throttle_burst_limit   = 1000
    throttle_rate_limit    = 500
  }
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "method_path" {
  type    = string
  default = "*/*"
}

variable "monitoring_settings" {
  default = {
    "metrics_enabled"        = true
    "data_trace_enabled"     = true
    "logging_level"          = "INFO"
    "throttling_rate_limit"  = 100
    "throttling_burst_limit" = 50
  }
}

variable "custom_domain" {
  type = object({
    name      = string # this is just first/prefix/subdomain part of domain without zone part
    zone_name = string
  })
  default = {
    name      = ""
    zone_name = ""
  }
  description = "Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one"
}

variable "set_account_settings" {
  type        = bool
  default     = false
  description = "The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn"
}
