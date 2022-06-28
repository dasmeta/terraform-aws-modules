Module use examples.

```
module "api_gateway" {
  source = "../terraform-aws-modules/modules/api-gateway"
  name = "api_gw"
  endpoint_config_type = "REGIONAL"
  stage_name = "api-stage"
}

output "access_key_id" {
  value = module.api_gateway.access_key_id
}

output "access_secret_key" {
  value = nonsensitive(module.api_gateway.access_secret_key)
}
```
