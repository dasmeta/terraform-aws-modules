<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | n/a     |

## Modules

No modules.

## Resources

| Name                                                                                                      | Type     |
| --------------------------------------------------------------------------------------------------------- | -------- |
| [aws_mq_broker.mq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |

## Inputs

| Name                                                                                                            | Description | Type           | Default              | Required |
| --------------------------------------------------------------------------------------------------------------- | ----------- | -------------- | -------------------- | :------: |
| <a name="input_auto_minor_version_upgrade"></a> [auto_minor_version_upgrade](#input_auto_minor_version_upgrade) | n/a         | `bool`         | `true`               |    no    |
| <a name="input_broker_name"></a> [broker_name](#input_broker_name)                                              | n/a         | `string`       | n/a                  |   yes    |
| <a name="input_deployment_mode"></a> [deployment_mode](#input_deployment_mode)                                  | n/a         | `string`       | `"CLUSTER_MULTI_AZ"` |    no    |
| <a name="input_engine_type"></a> [engine_type](#input_engine_type)                                              | n/a         | `string`       | `"RabbitMQ"`         |    no    |
| <a name="input_engine_version"></a> [engine_version](#input_engine_version)                                     | n/a         | `string`       | `"3.8.11"`           |    no    |
| <a name="input_host_instance_type"></a> [host_instance_type](#input_host_instance_type)                         | n/a         | `string`       | `"mq.m5.large"`      |    no    |
| <a name="input_mw_day_of_week"></a> [mw_day_of_week](#input_mw_day_of_week)                                     | n/a         | `string`       | `"SUNDAY"`           |    no    |
| <a name="input_mw_time_of_day"></a> [mw_time_of_day](#input_mw_time_of_day)                                     | n/a         | `string`       | `"03:00"`            |    no    |
| <a name="input_mw_time_zone"></a> [mw_time_zone](#input_mw_time_zone)                                           | n/a         | `string`       | `"UTC"`              |    no    |
| <a name="input_password"></a> [password](#input_password)                                                       | n/a         | `string`       | n/a                  |   yes    |
| <a name="input_publicly_accessible"></a> [publicly_accessible](#input_publicly_accessible)                      | n/a         | `bool`         | `false`              |    no    |
| <a name="input_security_groups"></a> [security_groups](#input_security_groups)                                  | n/a         | `list(string)` | n/a                  |   yes    |
| <a name="input_storage_type"></a> [storage_type](#input_storage_type)                                           | n/a         | `string`       | `"ebs"`              |    no    |
| <a name="input_subnet_ids"></a> [subnet_ids](#input_subnet_ids)                                                 | n/a         | `any`          | n/a                  |   yes    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                   | n/a         | `map(any)`     | `{}`                 |    no    |
| <a name="input_username"></a> [username](#input_username)                                                       | n/a         | `string`       | n/a                  |   yes    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
