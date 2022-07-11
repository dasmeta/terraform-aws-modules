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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.20.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_deployment.aws-api-depl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_integration.aws_api_integr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_integration) | resource |
| [aws_api_gateway_method.api_method](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method) | resource |
| [aws_api_gateway_rest_api.api-gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.aws-api-stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_api_gateway_usage_plan.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan) | resource |
| [aws_iam_access_key.api-gw-ak](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.api-gw-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.api-gw-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_user"></a> [create\_user](#input\_create\_user) | n/a | `bool` | `true` | no |
| <a name="input_endpoint_config_type"></a> [endpoint\_config\_type](#input\_endpoint\_config\_type) | n/a | `string` | `"REGIONAL"` | no |
| <a name="input_iam_username"></a> [iam\_username](#input\_iam\_username) | username of newly created IAM user | `string` | `"api-gw-user"` | no |
| <a name="input_integration_values"></a> [integration\_values](#input\_integration\_values) | n/a | `map(string)` | <pre>{<br>  "endpoint_uri": "https://www.google.de",<br>  "header_mapto": "method.request.header.x-api-key",<br>  "header_name": "integration.request.header.x-api-key",<br>  "integration_http_method": "GET",<br>  "type": "HTTP"<br>}</pre> | no |
| <a name="input_method_values"></a> [method\_values](#input\_method\_values) | n/a | `map(string)` | <pre>{<br>  "api_key_required": "true",<br>  "authorization": "NONE",<br>  "http_method": "POST"<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"api-gw"` | no |
| <a name="input_open_api_path"></a> [open\_api\_path](#input\_open\_api\_path) | n/a | `string` | `""` | no |
| <a name="input_pgp_key"></a> [pgp\_key](#input\_pgp\_key) | Either a base-64 encoded PGP public key, or a keybase username in the form `keybase:username`. Used to encrypt password and access key. `pgp_key` is required when `create_iam_user_login_profile` is set to `true` | `string` | `""` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | API Gateway policy name | `string` | `"api-gw-policy"` | no |
| <a name="input_rest_api_id"></a> [rest\_api\_id](#input\_rest\_api\_id) | n/a | `string` | `""` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | `"api-stage"` | no |
| <a name="input_usage_plan_values"></a> [usage\_plan\_values](#input\_usage\_plan\_values) | n/a | `map` | <pre>{<br>  "quota_limit": 10000,<br>  "quota_period": "MONTH",<br>  "throttle_burst_limit": 1000,<br>  "throttle_rate_limit": 500,<br>  "usage_plan_description": "my description",<br>  "usage_plan_name": "my-usage-plan"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | n/a |
| <a name="output_access_secret_key"></a> [access\_secret\_key](#output\_access\_secret\_key) | n/a |
| <a name="output_execution_arn"></a> [execution\_arn](#output\_execution\_arn) | The Execution ARN of the REST API. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the REST API. |
<!-- END_TF_DOCS -->
