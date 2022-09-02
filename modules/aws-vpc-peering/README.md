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

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.37   |

## Providers

| Name                                                            | Version |
| --------------------------------------------------------------- | ------- |
| <a name="provider_aws.peer"></a> [aws.peer](#provider_aws.peer) | >= 3.37 |
| <a name="provider_aws.this"></a> [aws.this](#provider_aws.this) | >= 3.37 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                             | Type        |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_route.peer_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                       | resource    |
| [aws_route.this_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)                                                       | resource    |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection)                            | resource    |
| [aws_vpc_peering_connection_accepter.peer_accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource    |
| [aws_vpc_peering_connection_options.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options)        | resource    |
| [aws_vpc_peering_connection_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_options)            | resource    |
| [aws_caller_identity.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                       | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                       | data source |
| [aws_region.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                         | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                         | data source |
| [aws_route_table.peer_subnet_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table)                                    | data source |
| [aws_route_table.this_subnet_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table)                                    | data source |
| [aws_route_tables.peer_vpc_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables)                                     | data source |
| [aws_route_tables.this_vpc_rts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables)                                     | data source |
| [aws_subnet.peer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                                                         | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                                                         | data source |
| [aws_vpc.peer_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                                                           | data source |
| [aws_vpc.this_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                                                           | data source |

## Inputs

| Name                                                                                                            | Description                                                                                                                      | Type           | Default | Required |
| --------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | :------: |
| <a name="input_auto_accept_peering"></a> [auto_accept_peering](#input_auto_accept_peering)                      | Auto accept peering connection: bool                                                                                             | `bool`         | `false` |    no    |
| <a name="input_aws_peer"></a> [aws_peer](#input_aws_peer)                                                       | Peer VPC ID: string                                                                                                              | `string`       | `"aws"` |    no    |
| <a name="input_aws_this"></a> [aws_this](#input_aws_this)                                                       | Peer VPC ID: string                                                                                                              | `string`       | `"aws"` |    no    |
| <a name="input_create_vpc_peering"></a> [create_vpc_peering](#input_create_vpc_peering)                         | Whether or not to create a VPC Peering.                                                                                          | `bool`         | `false` |    no    |
| <a name="input_from_peer"></a> [from_peer](#input_from_peer)                                                    | If traffic FROM peer vpc (to this) should be allowed                                                                             | `bool`         | `true`  |    no    |
| <a name="input_from_this"></a> [from_this](#input_from_this)                                                    | If traffic TO peer vpc (from this) should be allowed                                                                             | `bool`         | `true`  |    no    |
| <a name="input_peer_dns_resolution"></a> [peer_dns_resolution](#input_peer_dns_resolution)                      | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC | `bool`         | `false` |    no    |
| <a name="input_peer_link_to_local_classic"></a> [peer_link_to_local_classic](#input_peer_link_to_local_classic) | Indicates whether a local VPC can communicate with a ClassicLink connection in the peer VPC over the VPC Peering Connection      | `bool`         | `false` |    no    |
| <a name="input_peer_link_to_peer_classic"></a> [peer_link_to_peer_classic](#input_peer_link_to_peer_classic)    | Indicates whether a local ClassicLink connection can communicate with the peer VPC over the VPC Peering Connection               | `bool`         | `false` |    no    |
| <a name="input_peer_rts_ids"></a> [peer_rts_ids](#input_peer_rts_ids)                                           | Allows to explicitly specify route tables for peer VPC                                                                           | `list(string)` | `[]`    |    no    |
| <a name="input_peer_subnets_ids"></a> [peer_subnets_ids](#input_peer_subnets_ids)                               | If communication can only go to some specific subnets of peer vpc. If empty whole vpc cidr is allowed                            | `list(string)` | `[]`    |    no    |
| <a name="input_peer_vpc_id"></a> [peer_vpc_id](#input_peer_vpc_id)                                              | Peer VPC ID: string                                                                                                              | `string`       | `""`    |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                   | Tags: map                                                                                                                        | `map(string)`  | `{}`    |    no    |
| <a name="input_this_dns_resolution"></a> [this_dns_resolution](#input_this_dns_resolution)                      | Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a this VPC | `bool`         | `false` |    no    |
| <a name="input_this_link_to_local_classic"></a> [this_link_to_local_classic](#input_this_link_to_local_classic) | Indicates whether a local VPC can communicate with a ClassicLink connection in the this VPC over the VPC Peering Connection      | `bool`         | `false` |    no    |
| <a name="input_this_link_to_peer_classic"></a> [this_link_to_peer_classic](#input_this_link_to_peer_classic)    | Indicates whether a local ClassicLink connection can communicate with the this VPC over the VPC Peering Connection               | `bool`         | `false` |    no    |
| <a name="input_this_rts_ids"></a> [this_rts_ids](#input_this_rts_ids)                                           | Allows to explicitly specify route tables for this VPC                                                                           | `list(string)` | `[]`    |    no    |
| <a name="input_this_subnets_ids"></a> [this_subnets_ids](#input_this_subnets_ids)                               | If communication can only go to some specific subnets of this vpc. If empty whole vpc cidr is allowed                            | `list(string)` | `[]`    |    no    |
| <a name="input_this_vpc_id"></a> [this_vpc_id](#input_this_vpc_id)                                              | This VPC ID: string                                                                                                              | `string`       | `""`    |    no    |

## Outputs

| Name                                                                                                                                         | Description                                              |
| -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| <a name="output_accepter_options"></a> [accepter_options](#output_accepter_options)                                                          | VPC Peering Connection options set for the accepter VPC  |
| <a name="output_accepter_routes"></a> [accepter_routes](#output_accepter_routes)                                                             | Routes to the accepter VPC                               |
| <a name="output_aws_vpc_peering_connection"></a> [aws_vpc_peering_connection](#output_aws_vpc_peering_connection)                            | n/a                                                      |
| <a name="output_aws_vpc_peering_connection_accepter"></a> [aws_vpc_peering_connection_accepter](#output_aws_vpc_peering_connection_accepter) | n/a                                                      |
| <a name="output_peer_owner_id"></a> [peer_owner_id](#output_peer_owner_id)                                                                   | The AWS account ID of the owner of the accepter VPC      |
| <a name="output_peer_region"></a> [peer_region](#output_peer_region)                                                                         | The region of the accepter VPC                           |
| <a name="output_peer_vpc_id"></a> [peer_vpc_id](#output_peer_vpc_id)                                                                         | The ID of the accepter VPC                               |
| <a name="output_requester_options"></a> [requester_options](#output_requester_options)                                                       | VPC Peering Connection options set for the requester VPC |
| <a name="output_requester_routes"></a> [requester_routes](#output_requester_routes)                                                          | Routes from the requester VPC                            |
| <a name="output_this_owner_id"></a> [this_owner_id](#output_this_owner_id)                                                                   | The AWS account ID of the owner of the requester VPC     |
| <a name="output_this_vpc_id"></a> [this_vpc_id](#output_this_vpc_id)                                                                         | The ID of the requester VPC                              |
| <a name="output_vpc_peering_accept_status"></a> [vpc_peering_accept_status](#output_vpc_peering_accept_status)                               | Accept status for the connection                         |
| <a name="output_vpc_peering_id"></a> [vpc_peering_id](#output_vpc_peering_id)                                                                | Peering connection ID                                    |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
