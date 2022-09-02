<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name                                         | Source                        | Version |
| -------------------------------------------- | ----------------------------- | ------- |
| <a name="module_vpc"></a> [vpc](#module_vpc) | terraform-aws-modules/vpc/aws | 2.77.0  |

## Resources

No resources.

## Inputs

| Name                                                                                          | Description                                                                      | Type           | Default | Required |
| --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)       | List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']. | `list(string)` | n/a     |   yes    |
| <a name="input_cidr"></a> [cidr](#input_cidr)                                                 | CIDR ip range.                                                                   | `string`       | n/a     |   yes    |
| <a name="input_create_vpc"></a> [create_vpc](#input_create_vpc)                               | Whether or not to create a VPC.                                                  | `bool`         | `true`  |    no    |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames) | Whether or not to enable dns hostnames.                                          | `bool`         | `true`  |    no    |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support)       | Whether or not to enable dns support.                                            | `bool`         | `true`  |    no    |
| <a name="input_enable_nat_gateway"></a> [enable_nat_gateway](#input_enable_nat_gateway)       | Whether or not to enable NAT Gateway.                                            | `bool`         | `true`  |    no    |
| <a name="input_private_subnet_tags"></a> [private_subnet_tags](#input_private_subnet_tags)    | n/a                                                                              | `map(any)`     | `{}`    |    no    |
| <a name="input_private_subnets"></a> [private_subnets](#input_private_subnets)                | Private subnets of VPC.                                                          | `list(string)` | n/a     |   yes    |
| <a name="input_public_subnet_tags"></a> [public_subnet_tags](#input_public_subnet_tags)       | n/a                                                                              | `map(any)`     | `{}`    |    no    |
| <a name="input_public_subnets"></a> [public_subnets](#input_public_subnets)                   | Public subnets of VPC.                                                           | `list(string)` | n/a     |   yes    |
| <a name="input_single_nat_gateway"></a> [single_nat_gateway](#input_single_nat_gateway)       | Whether or not to enable single NAT Gateway.                                     | `bool`         | `true`  |    no    |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name)                                     | VPC name.                                                                        | `string`       | n/a     |   yes    |

## Outputs

| Name                                                                                                           | Description |
| -------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_default_security_group_id"></a> [default_security_group_id](#output_default_security_group_id) | n/a         |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block)                                  | n/a         |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                                                          | n/a         |
| <a name="output_vpc_private_subnets"></a> [vpc_private_subnets](#output_vpc_private_subnets)                   | n/a         |
| <a name="output_vpc_public_subnets"></a> [vpc_public_subnets](#output_vpc_public_subnets)                      | n/a         |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
