# Allows to create/setup AWS API Gateway resources with configurable manner


## Module use examples.

### Module usage without "access secret key" encryption, so it will be directly outputed to console (Not secure)

```hcl
module "api_gateway" {
  source = "dasmeta/modules/aws//modules/api-gateway"

  name = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name = "api-stage"

  root_resource_configs = {
    ANY = {
        authorization    = "NONE"
        api_key_required = true

        integration = {
          type                    = "HTTP"
          endpoint_uri            = "https://www.google.de"
          integration_http_method = "ANY"
          request_parameters      = { "integration.request.header.x-api-key" = "method.request.header.x-api-key" }
        }
    }
  }

  usage_plan_values = {}

  providers = {
    aws.virginia = aws.virginia
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

output "access_key_id" {
  value = module.api_gateway.access_key_id
}

output "access_secret_key" {
  value = nonsensitive(module.api_gateway.access_secret_key)
}
```

### Module usage with PGP encryption

```
module "api_gateway" {
  source = "dasmeta/modules/aws//modules/api-gateway"

  name = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name = "api-stage"
  pgp_key = "keybase:miandevops"

    root_resource_configs = {
    POST = {
        authorization    = "NONE"
        api_key_required = true

        integration = {
          type                    = "HTTP"
          endpoint_uri            = "https://www.google.de"
          integration_http_method = "POST"
          request_parameters      = { "integration.request.header.x-api-key" = "method.request.header.x-api-key" }
        }
    }
  }

  usage_plan_values = {}

  providers = {
    aws.virginia = aws.virginia
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

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
```
In this case your output of `secret_access_key` will be something like this:
```
secret_access_key = <<EOT

${COMMAND}

EOT
```
You have to copy the {COMMAND} and run in shell/console.

### create api-gateway with Swagger/OpenAPI json config file, without user creation, with custom domain, with monitoring/logging enabled, with configuring account stings for cloudwatch
#### here you can get the file [./examples/swagger-config-example.json](./examples/swagger-config-example.json)

```hcl
module "api_gateway" {
  source  = "dasmeta/modules/aws//modules/api-gateway"

  name                  = "my-super-api"
  endpoint_config_type  = "EDGE"
  body                  = file("./examples/swagger-config-example.json")
  root_resource_configs = {}

  stage_name           = prod
  usage_plan_values    = {}
  create_iam_user      = false
  custom_domain        = {
    name      = "super-api"
    zone_name = "mega.example.com"
  }
  enable_monitoring    = true
  monitoring_settings  = monitoring_settings = {
    metrics_enabled        = true
    data_trace_enabled     = true
    logging_level          = "INFO"
    throttling_rate_limit  = 200
    throttling_burst_limit = 250
  }
  set_account_settings = true

  providers = {
    aws.virginia = aws.virginia
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
```


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
| <a name="module_api_iam_user"></a> [api\_iam\_user](#module\_api\_iam\_user) | dasmeta/modules/aws//modules/aws-iam-user | 0.35.5 |
| <a name="module_custom_domain"></a> [custom\_domain](#module\_custom\_domain) | ./custom-domain | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.root_methods_integrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.root_methods_integration_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.root_methods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.root_methods_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_settings.general_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.usage_plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_cloudwatch_log_group.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_format"></a> [access\_logs\_format](#input\_access\_logs\_format) | The access logs format to sync into cloudwatch log group | `string` | `"{ \"requestId\":\"$context.requestId\", \"resourcePath\":\"$context.resourcePath\", \"httpMethod\":\"$context.httpMethod\", \"responseLength\":\"$context.responseLength\", \"responseLatency\":\"$context.responseLatency\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"extendedRequestId\":\"$context.extendedRequestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"userAgent\":\"$context.identity.userAgent\", \"requestTime\":\"$context.requestTime\"}\n"` | no |
| <a name="input_body"></a> [body](#input\_body) | An OpenAPI/Sagger specification json string with description of paths/resources/methods, check AWS docs for more info: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html | `string` | `null` | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Whether to create specific api access user to api gateway./[''871]. | `bool` | `true` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one | <pre>object({<br>    name      = string # this is just first/prefix/subdomain part of domain without zone part<br>    zone_name = string<br>  })</pre> | <pre>{<br>  "name": "",<br>  "zone_name": ""<br>}</pre> | no |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Weather enable or not the access logs on stage | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | n/a | `bool` | `true` | no |
| <a name="input_endpoint_config_type"></a> [endpoint\_config\_type](#input\_endpoint\_config\_type) | API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE | `string` | `"REGIONAL"` | no |
| <a name="input_method_path"></a> [method\_path](#input\_method\_path) | n/a | `string` | `"*/*"` | no |
| <a name="input_monitoring_settings"></a> [monitoring\_settings](#input\_monitoring\_settings) | n/a | `map` | <pre>{<br>  "data_trace_enabled": true,<br>  "logging_level": "INFO",<br>  "metrics_enabled": true,<br>  "throttling_burst_limit": 50,<br>  "throttling_rate_limit": 100<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of API gateway | `string` | n/a | yes |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true` | `string` | `null` | no |
| <a name="input_root_resource_configs"></a> [root\_resource\_configs](#input\_root\_resource\_configs) | The methods/methods\_responses/integrations configs for root '/' resource, the key is HTTPS method like ANY/POST/GET | `any` | <pre>{<br>  "POST": {<br>    "api_key_required": true,<br>    "authorization": "NONE",<br>    "integration": {<br>      "endpoint_uri": "https://www.google.de",<br>      "integration_http_method": null,<br>      "request_parameters": {<br>        "integration.request.header.x-api-key": "method.request.header.x-api-key"<br>      },<br>      "type": "HTTP"<br>    },<br>    "request_parameters": {},<br>    "response": {<br>      "models": null,<br>      "status_code": "200"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_set_account_settings"></a> [set\_account\_settings](#input\_set\_account\_settings) | The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn | `bool` | `false` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | `"api-stage"` | no |
| <a name="input_usage_plan_values"></a> [usage\_plan\_values](#input\_usage\_plan\_values) | n/a | `any` | <pre>{<br>  "quota_limit": 10000,<br>  "quota_period": "MONTH",<br>  "throttle_burst_limit": 1000,<br>  "throttle_rate_limit": 500,<br>  "usage_plan_description": "my description",<br>  "usage_plan_name": "my-usage-plan"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The access key ID |
| <a name="output_access_secret_key"></a> [access\_secret\_key](#output\_access\_secret\_key) | The access key secret |
| <a name="output_access_secret_key_encrypted"></a> [access\_secret\_key\_encrypted](#output\_access\_secret\_key\_encrypted) | The access key secret with pgp encryption |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | The Execution ARN of the REST API. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the REST API. |
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="module_api_iam_user"></a> [api\_iam\_user](#module\_api\_iam\_user) | dasmeta/modules/aws//modules/aws-iam-user | 0.35.5 |
| <a name="module_custom_domain"></a> [custom\_domain](#module\_custom\_domain) | ./custom-domain | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.root_methods_integrations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_integration_response.root_methods_integration_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration_response) | resource |
| [aws_api_gateway_method.root_methods](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_method_response.root_methods_responses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_response) | resource |
| [aws_api_gateway_method_settings.general_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.usage_plan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_cloudwatch_log_group.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs_format"></a> [access\_logs\_format](#input\_access\_logs\_format) | The access logs format to sync into cloudwatch log group | `string` | `"{ \"requestId\":\"$context.requestId\", \"resourcePath\":\"$context.resourcePath\", \"httpMethod\":\"$context.httpMethod\", \"responseLength\":\"$context.responseLength\", \"responseLatency\":\"$context.responseLatency\", \"status\":\"$context.status\", \"protocol\":\"$context.protocol\", \"extendedRequestId\":\"$context.extendedRequestId\", \"ip\": \"$context.identity.sourceIp\", \"caller\":\"$context.identity.caller\", \"user\":\"$context.identity.user\", \"userAgent\":\"$context.identity.userAgent\", \"requestTime\":\"$context.requestTime\"}\n"` | no |
| <a name="input_body"></a> [body](#input\_body) | An OpenAPI/Sagger specification json string with description of paths/resources/methods, check AWS docs for more info: https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html | `string` | `null` | no |
| <a name="input_create_iam_user"></a> [create\_iam\_user](#input\_create\_iam\_user) | Whether to create specific api access user to api gateway./[''871]. | `bool` | `true` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | Allows to setup/attach custom domain to api gateway setup, it will create also r53 record and certificate. Note that all keys of object are required to pass when you need one | <pre>object({<br>    name      = string # this is just first/prefix/subdomain part of domain without zone part<br>    zone_name = string<br>  })</pre> | <pre>{<br>  "name": "",<br>  "zone_name": ""<br>}</pre> | no |
| <a name="input_enable_access_logs"></a> [enable\_access\_logs](#input\_enable\_access\_logs) | Weather enable or not the access logs on stage | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | n/a | `bool` | `true` | no |
| <a name="input_endpoint_config_type"></a> [endpoint\_config\_type](#input\_endpoint\_config\_type) | API Gateway config type. Valid values: EDGE, REGIONAL or PRIVATE | `string` | `"REGIONAL"` | no |
| <a name="input_method_path"></a> [method\_path](#input\_method\_path) | n/a | `string` | `"*/*"` | no |
| <a name="input_monitoring_settings"></a> [monitoring\_settings](#input\_monitoring\_settings) | n/a | `map` | <pre>{<br>  "data_trace_enabled": true,<br>  "logging_level": "INFO",<br>  "metrics_enabled": true,<br>  "throttling_burst_limit": 50,<br>  "throttling_rate_limit": 100<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of API gateway | `string` | n/a | yes |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true` | `string` | `null` | no |
| <a name="input_root_resource_configs"></a> [root\_resource\_configs](#input\_root\_resource\_configs) | The methods/methods\_responses/integrations configs for root '/' resource, the key is HTTPS method like ANY/POST/GET | `any` | <pre>{<br>  "POST": {<br>    "api_key_required": true,<br>    "authorization": "NONE",<br>    "integration": {<br>      "endpoint_uri": "https://www.google.de",<br>      "integration_http_method": null,<br>      "request_parameters": {<br>        "integration.request.header.x-api-key": "method.request.header.x-api-key"<br>      },<br>      "type": "HTTP"<br>    },<br>    "request_parameters": {},<br>    "response": {<br>      "models": null,<br>      "status_code": "200"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_set_account_settings"></a> [set\_account\_settings](#input\_set\_account\_settings) | The account setting is important to have per account region level set before enabling logging as it have important setting set for cloudwatch role arn | `bool` | `false` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | `"api-stage"` | no |
| <a name="input_usage_plan_values"></a> [usage\_plan\_values](#input\_usage\_plan\_values) | n/a | `any` | <pre>{<br>  "quota_limit": 10000,<br>  "quota_period": "MONTH",<br>  "throttle_burst_limit": 1000,<br>  "throttle_rate_limit": 500,<br>  "usage_plan_description": "my description",<br>  "usage_plan_name": "my-usage-plan"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The access key ID |
| <a name="output_access_secret_key"></a> [access\_secret\_key](#output\_access\_secret\_key) | The access key secret |
| <a name="output_access_secret_key_encrypted"></a> [access\_secret\_key\_encrypted](#output\_access\_secret\_key\_encrypted) | The access key secret with pgp encryption |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | The Execution ARN of the REST API. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the REST API. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
