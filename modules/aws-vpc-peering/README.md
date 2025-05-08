```
module "VPC Peering" {
  source = "../../"

  providers = {
    aws.this = aws
    aws.peer = aws
  }

  this_vpc_id = var.this_vpc_id
  peer_vpc_id = var.peer_vpc_id

  auto_accept_peering = true

  tags = {
    Name        = "vpc-peering"
    Environment = "Test"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.peer"></a> [aws.peer](#provider\_aws.peer) | ~> 5.0 |
| <a name="provider_aws.this"></a> [aws.this](#provider\_aws.this) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route.peer_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.this_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_vpc_peering_connection_accepter.peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options) | resource |
| [aws_caller_identity.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route_table.peer_subnet_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_table.this_subnet_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_route_tables.peer_vpc_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_route_tables.this_vpc_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables) | data source |
| [aws_subnet.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.peer_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc.this_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_accept_peering"></a> [auto\_accept\_peering](#input\_auto\_accept\_peering) | Auto accept peering connection: bool | `bool` | `false` | no |
| <a name="input_aws_peer"></a> [aws\_peer](#input\_aws\_peer) | Peer VPC ID: string | `string` | `"aws"` | no |
| <a name="input_aws_this"></a> [aws\_this](#input\_aws\_this) | Peer VPC ID: string | `string` | `"aws"` | no |
| <a name="input_create_vpc_peering"></a> [create\_vpc\_peering](#input\_create\_vpc\_peering) | Whether or not to create a VPC Peering. | `bool` | `false` | no |
| <a name="input_from_peer"></a> [from\_peer](#input\_from\_peer) | If traffic FROM peer vpc (to this) should be allowed | `bool` | `true` | no |
| <a name="input_from_this"></a> [from\_this](#input\_from\_this) | If traffic TO peer vpc (from this) should be allowed | `bool` | `true` | no |
| <a name="input_peer_dns_resolution"></a> [peer\_dns\_resolution](#input\_peer\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC | `bool` | `false` | no |
| <a name="input_peer_rts_ids"></a> [peer\_rts\_ids](#input\_peer\_rts\_ids) | Allows to explicitly specify route tables for peer VPC | `list(string)` | `[]` | no |
| <a name="input_peer_subnets_ids"></a> [peer\_subnets\_ids](#input\_peer\_subnets\_ids) | If communication can only go to some specific subnets of peer vpc. If empty whole vpc cidr is allowed | `list(string)` | `[]` | no |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | Peer VPC ID: string | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags: map | `map(string)` | `{}` | no |
| <a name="input_this_dns_resolution"></a> [this\_dns\_resolution](#input\_this\_dns\_resolution) | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a this VPC | `bool` | `false` | no |
| <a name="input_this_rts_ids"></a> [this\_rts\_ids](#input\_this\_rts\_ids) | Allows to explicitly specify route tables for this VPC | `list(string)` | `[]` | no |
| <a name="input_this_subnets_ids"></a> [this\_subnets\_ids](#input\_this\_subnets\_ids) | If communication can only go to some specific subnets of this vpc. If empty whole vpc cidr is allowed | `list(string)` | `[]` | no |
| <a name="input_this_vpc_id"></a> [this\_vpc\_id](#input\_this\_vpc\_id) | This VPC ID: string | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_options"></a> [accepter\_options](#output\_accepter\_options) | VPC Peering Connection options set for the accepter VPC |
| <a name="output_accepter_routes"></a> [accepter\_routes](#output\_accepter\_routes) | Routes to the accepter VPC |
| <a name="output_aws_vpc_peering_connection"></a> [aws\_vpc\_peering\_connection](#output\_aws\_vpc\_peering\_connection) | n/a |
| <a name="output_aws_vpc_peering_connection_accepter"></a> [aws\_vpc\_peering\_connection\_accepter](#output\_aws\_vpc\_peering\_connection\_accepter) | n/a |
| <a name="output_peer_owner_id"></a> [peer\_owner\_id](#output\_peer\_owner\_id) | The AWS account ID of the owner of the accepter VPC |
| <a name="output_peer_region"></a> [peer\_region](#output\_peer\_region) | The region of the accepter VPC |
| <a name="output_peer_vpc_id"></a> [peer\_vpc\_id](#output\_peer\_vpc\_id) | The ID of the accepter VPC |
| <a name="output_requester_options"></a> [requester\_options](#output\_requester\_options) | VPC Peering Connection options set for the requester VPC |
| <a name="output_requester_routes"></a> [requester\_routes](#output\_requester\_routes) | Routes from the requester VPC |
| <a name="output_this_owner_id"></a> [this\_owner\_id](#output\_this\_owner\_id) | The AWS account ID of the owner of the requester VPC |
| <a name="output_this_vpc_id"></a> [this\_vpc\_id](#output\_this\_vpc\_id) | The ID of the requester VPC |
| <a name="output_vpc_peering_accept_status"></a> [vpc\_peering\_accept\_status](#output\_vpc\_peering\_accept\_status) | Accept status for the connection |
| <a name="output_vpc_peering_id"></a> [vpc\_peering\_id](#output\_vpc\_peering\_id) | Peering connection ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
