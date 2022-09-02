# How To

This module you can use when create multiple vpc peering. You can have one main vpc and multiple peering.

### Example:

provider "aws" {
region = "us-east-1"
}

module "vpc_multi_peering" {
source = "../../terraform-aws-modules/modules/aws_multi_vpc_peering/"
main_vpc = "vpc-041abee1cf26e79dc"
peering_vpc_id = ["vpc-0bdf97ed6f2d42f37","vpc-063637d7c4597b4cf"]
region = "us-east-1"
}

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | > 0.15.0 |

## Providers

No providers.

## Modules

| Name                                                                 | Source             | Version |
| -------------------------------------------------------------------- | ------------------ | ------- |
| <a name="module_vpc_peering"></a> [vpc_peering](#module_vpc_peering) | ../aws-vpc-peering | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                        | Description      | Type           | Default | Required |
| --------------------------------------------------------------------------- | ---------------- | -------------- | ------- | :------: |
| <a name="input_main_vpc"></a> [main_vpc](#input_main_vpc)                   | MainVPC Id       | `string`       | n/a     |   yes    |
| <a name="input_peering_vpc_id"></a> [peering_vpc_id](#input_peering_vpc_id) | Peering VPC ids. | `list(string)` | n/a     |   yes    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
