Module use examples.

Module usage without "access secret key" encryption, so it will be directly outputed to console (Not secure)

```
module "api_gateway" {
  source = "dasmeta/modules/aws//modules/api-gateway"
  name = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name = "api-stage"

  integration_values = {
    "type" = "HTTP"
    "endpoint_uri" = "https://www.google.de"
    "integration_http_method" = "GET"
    "header_name" = "integration.request.header.x-api-key"
    "header_mapto" = "method.request.header.x-api-key"
  }

  method_values = {
    "http_method" = "POST"
    authorization = "NONE"
    "api_key_required" = "true"
  }

  usage_plan_values = {
    usage_plan_name = "my-usage-plan"
    "usage_plan_description" = "my description"
    "quota_limit" = 10000
    "quota_period" = "MONTH"
    "throttle_burst_limit" = 1000
    "throttle_rate_limit" = 500
  }
}

output "access_key_id" {
  value = module.api_gateway.access_key_id
}

output "access_secret_key" {
  value = nonsensitive(module.api_gateway.access_secret_key)
}
```

Module usage with PGP encryption

```
module "api_gateway" {
  source = "dasmeta/modules/aws//modules/api-gateway"
  name = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name = "api-stage"
  pgp_key = "keybase:miandevops"

  integration_values = {
    "type" = "HTTP"
    "endpoint_uri" = "https://www.google.de"
    "integration_http_method" = "GET"
    "header_name" = "integration.request.header.x-api-key"
    "header_mapto" = "method.request.header.x-api-key"
  }

  method_values = {
    "http_method" = "POST"
    authorization = "NONE"
    "api_key_required" = "true"
  }

  usage_plan_values = {
    usage_plan_name = "my-usage-plan"
    "usage_plan_description" = "my description"
    "quota_limit" = 10000
    "quota_period" = "MONTH"
    "throttle_burst_limit" = 1000
    "throttle_rate_limit" = 500
  }
}

output "access_key_id" {
  value = module.api_gateway.access_key_id
}

output "secret_access_key" {
  value       = module.api_gateway.access_secret_key_encrypted == "" ? null : <<EOF
export GPG_TTY=$(tty) && echo "${module.api_gateway.access_secret_key_encrypted}" | base64 --decode | gpg --decrypt
EOF
}
```
In this case your output of `secret_access_key` will be something like this:
```
secret_access_key = <<EOT

${COMMAND}

EOT
```
You have to copy the {COMMAND} and run in shell/console.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_settings"></a> [account\_settings](#module\_account\_settings) | ../api-gateway-account-settings | n/a |
| <a name="module_api_iam_user"></a> [api\_iam\_user](#module\_api\_iam\_user) | dasmeta/modules/aws//modules/aws-iam-user | 0.35.2 |
| <a name="module_certificate_edge"></a> [certificate\_edge](#module\_certificate\_edge) | dasmeta/modules/aws//modules/ssl-certificate | 0.34.0 |
| <a name="module_certificate_regional"></a> [certificate\_regional](#module\_certificate\_regional) | dasmeta/modules/aws//modules/ssl-certificate | 0.34.0 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.custom_domain_api_mapping](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.aws-api-depl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.custom_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_integration.aws_api_integr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.integration_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.api_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.method_response](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_settings.general_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.api-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.aws-api-stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_cloudwatch_log_group.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.custom_domain_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_format"></a> [access\_logs\_format](#input\_access\_logs\_format) | The access logs format to sync into cloudwatch log group | `string` | `"{ \"requestId\":\"$context.requestId\", \"resourcePath\":\"$context.resourcePath\", \"httpMethod\":\"$context.httpMethod\", \"responseLength\":\"$context.responseLength\", \"responseLatency\":\"$context.responseLatency\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"extendedRequestId\":\"$context.extendedRequestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"userAgent\":\"$context.identity.userAgent\", \"requestTime\":\"$context.requestTime\"}\n"` | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Whether to create specific api access user to api gateway./[''871]. | `bool` | `true` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Whether create a policy or not. | `bool` | `true` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one | <pre>object({<br>    name      = string # this is just first part of domain without zone part<br>    zone_name = string<br>  })</pre> | <pre>{<br>  "name": "",<br>  "zone_name": ""<br>}</pre> | no |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Weather enable or not the access logs on stage | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | n/a | `bool` | `true` | no |
| <a name="input_endpoint_config_type"></a> [endpoint\_config\_type](#input\_endpoint\_config\_type) | n/a | `string` | `"REGIONAL"` | no |
| <a name="input_iam_username"></a> [iam\_username](#input\_iam\_username) | username of newly created IAM user | `string` | `"api-gw-user"` | no |
| <a name="input_integration_values"></a> [integration\_values](#input\_integration\_values) | n/a | `any` | <pre>{<br>  "endpoint_uri": "https://www.google.de",<br>  "integration_http_method": "GET",<br>  "request_parameters": {<br>    "integration.request.header.x-api-key": "method.request.header.x-api-key"<br>  },<br>  "type": "HTTP"<br>}</pre> | no |
| <a name="input_method_path"></a> [method\_path](#input\_method\_path) | n/a | `string` | `"*/*"` | no |
| <a name="input_method_values"></a> [method\_values](#input\_method\_values) | n/a | `any` | <pre>{<br>  "api_key_required": true,<br>  "authorization": "NONE",<br>  "http_method": "POST",<br>  "request_parameters": {}<br>}</pre> | no |
| <a name="input_monitoring_settings"></a> [monitoring\_settings](#input\_monitoring\_settings) | n/a | `map` | <pre>{<br>  "data_trace_enabled": true,<br>  "logging_level": "INFO",<br>  "metrics_enabled": true,<br>  "throttling_burst_limit": 50,<br>  "throttling_rate_limit": 100<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"api-gw"` | no |
| <a name="input_open_api_path"></a> [open\_api\_path](#input\_open\_api\_path) | n/a | `string` | `""` | no |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true` | `string` | `null` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | API Gateway policy name | `string` | `"api-gw-policy"` | no |
| <a name="input_response_models"></a> [response\_models](#input\_response\_models) | A map of the API models used for the response's content type. | `map(any)` | `null` | no |
| <a name="input_rest_api_id"></a> [rest\_api\_id](#input\_rest\_api\_id) | n/a | `string` | `""` | no |
| <a name="input_set_account_settings"></a> [set\_account\_settings](#input\_set\_account\_settings) | The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn | `bool` | `false` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | `"api-stage"` | no |
| <a name="input_usage_plan_values"></a> [usage\_plan\_values](#input\_usage\_plan\_values) | n/a | `map` | <pre>{<br>  "quota_limit": 10000,<br>  "quota_period": "MONTH",<br>  "throttle_burst_limit": 1000,<br>  "throttle_rate_limit": 500,<br>  "usage_plan_description": "my description",<br>  "usage_plan_name": "my-usage-plan"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The access key ID |
| <a name="output_access_secret_key"></a> [access\_secret\_key](#output\_access\_secret\_key) | The access key secret |
| <a name="output_access_secret_key_encrypted"></a> [access\_secret\_key\_encrypted](#output\_access\_secret\_key\_encrypted) | The access key secret with pgp encryption |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | The Execution ARN of the REST API. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the REST API. |
<!-- END_TF_DOCS -->
