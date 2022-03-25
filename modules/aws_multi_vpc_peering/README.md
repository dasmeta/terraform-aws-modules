# How To
This module you can use when create multiple vpc peering. You can have one main vpc and multiple peering.

### Example: 

provider "aws" {
    region = "us-east-1"
}

module "vpc_multi_peering" {
    source         = "../../terraform-aws-modules/modules/aws_multi_vpc_peering/"
    main_vpc       = "vpc-041abee1cf26e79dc"
    peering_vpc_id = ["vpc-0bdf97ed6f2d42f37","vpc-063637d7c4597b4cf"]
    region         = "us-east-1"
}
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | dasmeta/modules/aws//modules/aws-vpc-peering | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_main_vpc"></a> [main\_vpc](#input\_main\_vpc) | MainVPC Id | `string` | n/a | yes |
| <a name="input_peering_vpc_id"></a> [peering\_vpc\_id](#input\_peering\_vpc\_id) | Peering VPC ids. | `list(string)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Regioin | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->