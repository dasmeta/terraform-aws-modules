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