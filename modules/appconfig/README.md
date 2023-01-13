## allows to create aws app config setup for using as feature toggle

## TODO: there is such issue that it update/deploy the config each time when we terraform apply even no change is params, please investigate to find solution for this

### usage example
```hcl
module "feature-configs" {
  source = "dasmeta/modules/aws//modules/appconfig"

  name = "test application2"
  environments = [
    {
      name = "dev"
      deploys = [
        {
          config  = "test-config"
          version = "1"
        }
      ]
    },
    {
      name = "test"
      deploys = [
        {
          config  = "test-config"
          version = "2"
        }
      ]
    }
  ]

  configs = [
    {
      name    = "test-config"
      version = "1"
      flags = [
        {
          name    = "foo"
          enabled = true
          attributes = [
            {
              name  = "test-attribute-3"
              type  = "boolean"
              value = true
            }
          ]
        },
        {
          name    = "bar"
          enabled = true
          attributes = [
            {
              name  = "test-attribute-1"
              type  = "string"
              value = "test-attribute-1 value"
            },
            {
              name  = "test-attribute-2"
              type  = "number"
              value = 123
            }
          ]
        },
        {
          name    = "baz"
          enabled = true
        }
      ]
    },
    {
      name    = "test-config"
      version = "2"
      flags = [
        {
          name    = "foo"
          enabled = false
        },
        {
          name    = "bar"
          enabled = true
          attributes = [
            {
              name  = "test-attribute-1"
              type  = "string"
              value = "test-attribute-1 value"
            }
          ]
        }
      ]
    }
  ]
}

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appconfig_application.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_appconfig_configuration_profile.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile) | resource |
| [aws_appconfig_deployment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment) | resource |
| [aws_appconfig_deployment_strategy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy) | resource |
| [aws_appconfig_environment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment) | resource |
| [aws_appconfig_hosted_configuration_version.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_hosted_configuration_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configs"></a> [configs](#input\_configs) | List of configuration profiles/flags | <pre>list(object({<br>    name         = string<br>    content_type = optional(string, "application/json")<br>    version      = optional(string, "1")<br>    content      = optional(string, null) # in case some specific content needs to be set you can use this field instead of flags, but usually the flags should be used<br>    flags = optional(list(object({<br>      name               = string<br>      enabled            = optional(bool, false)<br>      deprecation_status = optional(string, null)<br>      attributes = optional(list(object({<br>        name     = string<br>        type     = optional(string, "string")<br>        required = optional(bool, true)<br>        value    = optional(string, "")<br>      })), [])<br>    })), [])<br>    description  = optional(string, "")<br>    location_uri = optional(string, "hosted")<br>    type         = optional(string, "AWS.AppConfig.FeatureFlags")<br>    validators = optional(list(object({<br>      type    = optional(string, "JSON_SCHEMA")<br>      content = optional(string, null)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_deployment_strategies"></a> [deployment\_strategies](#input\_deployment\_strategies) | List of deployment strategies with configs | <pre>list(object({<br>    name                           = string # the name should be unique<br>    description                    = optional(string, null)<br>    deployment_duration_in_minutes = optional(number, 3)<br>    final_bake_time_in_minutes     = optional(number, 4)<br>    growth_factor                  = optional(number, 10)<br>    growth_type                    = optional(string, "LINEAR")<br>    replicate_to                   = optional(string, "NONE")<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | Application description | `string` | `""` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | List of environments with configs | <pre>list(object({<br>    name                           = string # the name should be unique<br>    description                    = optional(string, null)<br>    deployment_duration_in_minutes = optional(number, 3)<br>    deploys = optional(list(object({<br>      config   = string<br>      strategy = optional(string, "AppConfig.AllAtOnce")<br>      version  = optional(string, "1")<br>    })), [])<br>    monitors = optional(list(object({<br>      alarm_arn      = string<br>      alarm_role_arn = string<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Application name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application"></a> [application](#output\_application) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
