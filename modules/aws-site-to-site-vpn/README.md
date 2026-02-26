# AWS Site-to-Site VPN Module

Creates an AWS Site-to-Site VPN between an AWS VPC and an on-premise network (customer gateway).

## Resources

- **VPN Gateway** – Attached to the VPC (optional; can use an existing one).
- **Customer Gateway** – Represents the on-premise VPN device (public IP and BGP ASN).
- **VPN Connection** – Site-to-site IPSec connection with two tunnels for redundancy.
- **Static routes** – Optional routes advertised to on-premise when not using BGP.
- **VPC routes** – Optional routes in specified route tables toward on-premise CIDRs via the VPN.

## Usage

### Basic (static routes)

```hcl
module "site_to_site_vpn" {
  source = "path/to/aws-site-to-site-vpn"

  name   = "onprem-vpn"
  vpc_id = aws_vpc.main.id

  customer_gateway = {
    ip_address  = "203.0.113.10"  # On-premise VPN device public IP
    bgp_asn     = "65000"
    type        = "ipsec.1"
    device_name = "onprem-fortigate"
  }

  static_routes_only = true
  static_routes      = ["10.0.0.0/16"]

  route_table_ids         = [aws_route_table.main.id]
  destination_cidr_blocks = ["192.168.0.0/16"]

  tunnel_options = {
    tunnel1_preshared_key = "your-psk-tunnel1"
    tunnel2_preshared_key = "your-psk-tunnel2"
    tunnel1_inside_cidr   = "169.254.21.0/30"
    tunnel2_inside_cidr   = "169.254.22.0/30"
  }

  tags = { Environment = "prod" }
}
```

### Using BGP (dynamic routing)

Set `static_routes_only = false` and omit `static_routes`. Ensure the on-premise device is configured for BGP with the same ASN as `customer_gateway.bgp_asn`.

### Using an existing VPN Gateway

```hcl
module "site_to_site_vpn" {
  source = "path/to/aws-site-to-site-vpn"

  name   = "onprem-vpn"
  vpc_id = aws_vpc.main.id

  create_vpn_gateway = false
  vpn_gateway_id     = aws_vpn_gateway.existing.id

  customer_gateway = { ... }
  # ...
}
```

## On-premise configuration

After applying:

1. Use **tunnel1_address** and **tunnel2_address** (from outputs or from `customer_gateway_configuration`) as the remote endpoints on the on-premise device.
2. Configure the same pre-shared keys and inside CIDRs if you set them in `tunnel_options`.
3. Add routes on the on-premise side for the VPC CIDR(s) via the VPN tunnels.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| name | Name prefix for resources | string | required |
| vpc_id | VPC to attach the VPN Gateway to | string | required |
| customer_gateway | On-premise device: ip_address, bgp_asn, type, device_name | object | required |
| static_routes_only | Use static routes instead of BGP | bool | false |
| static_routes | Destination CIDRs for static routes | list(string) | [] |
| route_table_ids | Route tables to add VPN routes | list(string) | [] |
| destination_cidr_blocks | CIDRs to route via VPN in VPC | list(string) | [] |
| tunnel_options | Preshared keys, inside CIDRs, IKE/phase options | object | {} |
| create_vpn_gateway | Create a new VPN Gateway | bool | true |
| vpn_gateway_id | Existing VPN Gateway ID when create_vpn_gateway = false | string | null |
| tags | Tags for all resources | map(string) | {} |

## Outputs

| Name | Description |
|------|-------------|
| vpn_connection_id | VPN connection ID |
| vpn_connection_tunnel1_address | AWS tunnel 1 public IP (remote endpoint for on-premise) |
| vpn_connection_tunnel2_address | AWS tunnel 2 public IP |
| vpn_connection_customer_gateway_configuration | XML config for on-premise device (sensitive) |
| vpn_gateway_id | VPN Gateway ID |
| customer_gateway_id | Customer Gateway ID |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_customer_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |
| [aws_route.vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpn_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection) | resource |
| [aws_vpn_connection_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_connection_route) | resource |
| [aws_vpn_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_vpn_gateway"></a> [create\_vpn\_gateway](#input\_create\_vpn\_gateway) | Set to false to use an existing VPN Gateway (pass vpn\_gateway\_id via vpn\_gateway\_id). | `bool` | `true` | no |
| <a name="input_customer_gateway"></a> [customer\_gateway](#input\_customer\_gateway) | On-premise VPN device: public IP, BGP ASN, and optional device name. | <pre>object({<br/>    ip_address  = string<br/>    bgp_asn     = optional(string, "65000")<br/>    type        = optional(string, "ipsec.1")<br/>    device_name = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_destination_cidr_blocks"></a> [destination\_cidr\_blocks](#input\_destination\_cidr\_blocks) | CIDR blocks to route through the VPN (typically on-premise networks). Used with route\_table\_ids to create routes. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name prefix for VPN Gateway, Customer Gateway, and VPN Connection resources. | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | Route table IDs where routes to the VPN (destination\_cidr\_blocks) will be added. Leave empty to manage routes elsewhere. | `list(string)` | `[]` | no |
| <a name="input_static_routes"></a> [static\_routes](#input\_static\_routes) | List of destination CIDR blocks for static routing (e.g. on-premise networks). Used when static\_routes\_only is true. | `list(string)` | `[]` | no |
| <a name="input_static_routes_only"></a> [static\_routes\_only](#input\_static\_routes\_only) | Set to true if the on-premise device does not support BGP. When true, provide static\_routes. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to VPN Gateway, Customer Gateway, and VPN Connection. | `map(string)` | `{}` | no |
| <a name="input_tunnel_options"></a> [tunnel\_options](#input\_tunnel\_options) | Tunnel options: pre-shared keys, inside CIDRs (/30), and optional IKE/phase algorithms. | <pre>object({<br/>    tunnel1_preshared_key                = optional(string, null)<br/>    tunnel2_preshared_key                = optional(string, null)<br/>    tunnel1_inside_cidr                  = optional(string, null)<br/>    tunnel2_inside_cidr                  = optional(string, null)<br/>    tunnel1_ike_versions                 = optional(list(string), null)<br/>    tunnel2_ike_versions                 = optional(list(string), null)<br/>    tunnel1_phase1_dh_group_numbers      = optional(list(number), null)<br/>    tunnel2_phase1_dh_group_numbers      = optional(list(number), null)<br/>    tunnel1_phase2_encryption_algorithms = optional(list(string), null)<br/>    tunnel2_phase2_encryption_algorithms = optional(list(string), null)<br/>    tunnel1_phase2_integrity_algorithms  = optional(list(string), null)<br/>    tunnel2_phase2_integrity_algorithms  = optional(list(string), null)<br/>  })</pre> | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to attach the VPN Gateway to. | `string` | n/a | yes |
| <a name="input_vpn_gateway_amazon_side_asn"></a> [vpn\_gateway\_amazon\_side\_asn](#input\_vpn\_gateway\_amazon\_side\_asn) | Amazon side BGP ASN for the VPN Gateway. Used only when create\_vpn\_gateway is true. | `string` | `"64512"` | no |
| <a name="input_vpn_gateway_id"></a> [vpn\_gateway\_id](#input\_vpn\_gateway\_id) | Existing VPN Gateway ID. Used when create\_vpn\_gateway is false; must be attached to vpc\_id elsewhere. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_gateway_id"></a> [customer\_gateway\_id](#output\_customer\_gateway\_id) | ID of the Customer Gateway (on-premise representation). |
| <a name="output_vpn_connection_arn"></a> [vpn\_connection\_arn](#output\_vpn\_connection\_arn) | ARN of the VPN connection. |
| <a name="output_vpn_connection_customer_gateway_configuration"></a> [vpn\_connection\_customer\_gateway\_configuration](#output\_vpn\_connection\_customer\_gateway\_configuration) | XML configuration for the on-premise VPN device. Use this to configure the device or derive tunnel endpoints and inside CIDRs. |
| <a name="output_vpn_connection_id"></a> [vpn\_connection\_id](#output\_vpn\_connection\_id) | ID of the VPN connection. |
| <a name="output_vpn_connection_static_routes_supported"></a> [vpn\_connection\_static\_routes\_supported](#output\_vpn\_connection\_static\_routes\_supported) | Whether the VPN connection supports static routes (true when static\_routes\_only is true). |
| <a name="output_vpn_connection_tunnel1_address"></a> [vpn\_connection\_tunnel1\_address](#output\_vpn\_connection\_tunnel1\_address) | Public IP address of the first VPN tunnel (AWS side). Configure this on the on-premise VPN device as the remote endpoint. |
| <a name="output_vpn_connection_tunnel2_address"></a> [vpn\_connection\_tunnel2\_address](#output\_vpn\_connection\_tunnel2\_address) | Public IP address of the second VPN tunnel (AWS side). Configure this on the on-premise VPN device as the second tunnel endpoint. |
| <a name="output_vpn_gateway_arn"></a> [vpn\_gateway\_arn](#output\_vpn\_gateway\_arn) | ARN of the VPN Gateway. Null if using an existing gateway. |
| <a name="output_vpn_gateway_id"></a> [vpn\_gateway\_id](#output\_vpn\_gateway\_id) | ID of the VPN Gateway (created or passed in). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
