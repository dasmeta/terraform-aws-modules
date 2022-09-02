# module allowing to create aws elastic-search/open-search domain

## usage minimum example

```terraform
module "elastic-search" {
  source = "dasmeta/modules/aws//modules/elastic-search"
  version = "0.33.6"

  domain_name = "my-new-es-domain-name"

  vpc_options_subnet_ids = [
    "subnet-00000000000000000",
    "subnet-11111111111111111"
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.64   |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.64 |

## Modules

| Name                                                                          | Source                     | Version |
| ----------------------------------------------------------------------------- | -------------------------- | ------- |
| <a name="module_elastic_search"></a> [elastic_search](#module_elastic_search) | lgallard/elasticsearch/aws | 0.14.1  |

## Resources

| Name                                                                                                                               | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_security_group.elastic_search_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)      | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                        | data source |
| [aws_subnet.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                       | data source |

## Inputs

| Name                                                                                                                                                                        | Description                                                                                                         | Type           | Default                           | Required |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | -------------- | --------------------------------- | :------: |
| <a name="input_access_policies"></a> [access_policies](#input_access_policies)                                                                                              | Custom access policies, if not provided one being generated automatically                                           | `string`       | `""`                              |    no    |
| <a name="input_availability_zone_count"></a> [availability_zone_count](#input_availability_zone_count)                                                                      | The number of availability zones of ES                                                                              | `number`       | `2`                               |    no    |
| <a name="input_dedicated_master_enabled"></a> [dedicated_master_enabled](#input_dedicated_master_enabled)                                                                   | Have dedicated master or not for ES                                                                                 | `bool`         | `false`                           |    no    |
| <a name="input_domain_name"></a> [domain_name](#input_domain_name)                                                                                                          | The domain name of ES                                                                                               | `string`       | n/a                               |   yes    |
| <a name="input_ebs_options_ebs_enabled"></a> [ebs_options_ebs_enabled](#input_ebs_options_ebs_enabled)                                                                      | Whether enable EBS for ES                                                                                           | `bool`         | `true`                            |    no    |
| <a name="input_ebs_options_volume_size"></a> [ebs_options_volume_size](#input_ebs_options_volume_size)                                                                      | Storage volume size in GB                                                                                           | `number`       | `10`                              |    no    |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt_at_rest_enabled](#input_encrypt_at_rest_enabled)                                                                      | Whether encrypt rest calls data                                                                                     | `bool`         | `false`                           |    no    |
| <a name="input_encrypt_at_rest_kms_key_id"></a> [encrypt_at_rest_kms_key_id](#input_encrypt_at_rest_kms_key_id)                                                             | The KMS key id to encrypt the ES domain with. If not specified then it defaults to using the aws/es service KMS key | `string`       | `"alias/aws/es"`                  |    no    |
| <a name="input_es_version"></a> [es_version](#input_es_version)                                                                                                             | The version of ES                                                                                                   | `string`       | `"7.1"`                           |    no    |
| <a name="input_instance_count"></a> [instance_count](#input_instance_count)                                                                                                 | The number of ES node instances                                                                                     | `number`       | `2`                               |    no    |
| <a name="input_instance_type"></a> [instance_type](#input_instance_type)                                                                                                    | The node instance types of ES                                                                                       | `string`       | `"t3.small.elasticsearch"`        |    no    |
| <a name="input_node_to_node_encryption_enabled"></a> [node_to_node_encryption_enabled](#input_node_to_node_encryption_enabled)                                              | Whether to enable node to node encryption                                                                           | `bool`         | `true`                            |    no    |
| <a name="input_snapshot_options_automated_snapshot_start_hour"></a> [snapshot_options_automated_snapshot_start_hour](#input_snapshot_options_automated_snapshot_start_hour) | The amount of ours to wait to snapshot of ES db                                                                     | `number`       | `0`                               |    no    |
| <a name="input_timeouts_update"></a> [timeouts_update](#input_timeouts_update)                                                                                              | The timeout update of ES                                                                                            | `string`       | `null`                            |    no    |
| <a name="input_vpc_options_security_group_whitelist_cidr"></a> [vpc_options_security_group_whitelist_cidr](#input_vpc_options_security_group_whitelist_cidr)                | The list of security group cidr blocks to whitelist in ingress                                                      | `list(string)` | <pre>[<br> "0.0.0.0/0"<br>]</pre> |    no    |
| <a name="input_vpc_options_security_group_whitelist_ids"></a> [vpc_options_security_group_whitelist_ids](#input_vpc_options_security_group_whitelist_ids)                   | The list of security group ids to whitelist in ingress                                                              | `list(string)` | `[]`                              |    no    |
| <a name="input_vpc_options_subnet_ids"></a> [vpc_options_subnet_ids](#input_vpc_options_subnet_ids)                                                                         | The list of vpc subnet ids, if availability_zone_count is two you have to pass two subnet ids                       | `list(string)` | n/a                               |   yes    |
| <a name="input_zone_awareness_enabled"></a> [zone_awareness_enabled](#input_zone_awareness_enabled)                                                                         | The zone awareness of ES                                                                                            | `bool`         | `true`                            |    no    |

## Outputs

| Name                                                                             | Description                          |
| -------------------------------------------------------------------------------- | ------------------------------------ |
| <a name="output_arn"></a> [arn](#output_arn)                                     | The ARN of the ES domain             |
| <a name="output_endpoint"></a> [endpoint](#output_endpoint)                      | The endpoint of the ES domain        |
| <a name="output_master_password"></a> [master_password](#output_master_password) | The master password of the ES domain |
| <a name="output_master_username"></a> [master_username](#output_master_username) | The master username of the ES domain |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
