module "api_gateway" {
  source = "../../"

  name                 = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name           = "api-stage"

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
