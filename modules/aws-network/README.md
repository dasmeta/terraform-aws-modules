# Terraform AWS Client VPN Endpoint 

## How to create Application for VPN in AWS Single Sign-On
- Create private certificate.
- Open AWS SSO service page. Select Applications from the sidebar
- Choose Add a new application
- Select Add a custom SAML 2.0 application
- Fill Display name and Description
- Set session duration (VPN session duration) - 12h
- Select "If you don't have a metadata file, you can manually type your metadata values."
- Application ACS URL: http://127.0.0.1:35001
- Application SAML audience: urn:amazon:webservices:clientvpn
- Save changes
- Download AWS SSO SAML metadata file (file for vpn secret)
- Select tab "Attribute mappings":
    - Subject -> ${user:subject} -> emailAddress
    - NameID -> ${user:email} -> basic
    - FirstName -> ${user:name} -> basic
    - LastName -> ${user:familyName} -> basic
- Select tab "Assigned users"
- Assign users or groups created on previous step

## Example
```hcl
module network {
    source      = "git::https://github.com/dasmeta/terraform.git//modules/newtwork?="
    
    #VPC Peering
    create_vpc_peering = false
    main_vpc_id        = "vpc-1234567889"
    peering_vpc_id     = "vpc-1234456789"
    peering_tags                = {
        Name        = "Peering Main to Slave"#
        Environment = "Hello"
    }
    # VPN Endpoint
    enable_saml                   = false
    vpc_id                        = "vpc-123456789"
    endpoint_name                 = "module_vpn"
    endpoint_client_cidr_block    = "10.100.0.0/16"
    saml_provider_arn             = "" # SAML Provider ARN
    certificate_arn               = "" # Certificate ARN
    authorization_ingress         = ["192.168.0.0/16","172.31.0.0/16","10.254.0.0/16"] # VPCs CIDRs
    endpoint_subnets              = ["subnet-111111111111111111","subnet-222222222222","subnet-3333333333333"]
    # VPC Create
    create_vpc                      = true
    vpc_name                        = "VPN-vpc"
    cidr                            = "172.254.0.0/16"
    availability_zones              = ["us-east-2a", "us-east-2b", "us-east-2c"]
    private_subnets                 = ["172.254.1.0/24", "172.254.2.0/24", "172.254.3.0/24"]
    public_subnets                  = ["172.254.4.0/24", "172.254.5.0/24", "172.254.6.0/24"]


}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 2.77.0 |
| <a name="module_vpc-peering"></a> [vpc-peering](#module\_vpc-peering) | ../aws-vpc-peering | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ../aws-vpn-vpnendpoint | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorization_ingress"></a> [authorization\_ingress](#input\_authorization\_ingress) | Add authorization rules to grant clients access to the networks. | `list(string)` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c']. | `list(string)` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate arn | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR ip range. | `string` | n/a | yes |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Whether or not to create a VPC. | `bool` | `true` | no |
| <a name="input_create_vpc_peering"></a> [create\_vpc\_peering](#input\_create\_vpc\_peering) | Whether or not to create a VPC Peering. | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether or not to enable dns hostnames. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether or not to enable dns support. | `bool` | `true` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Whether or not to enable NAT Gateway. | `bool` | `true` | no |
| <a name="input_enable_saml"></a> [enable\_saml](#input\_enable\_saml) | Whether or not to enable SAML Provider. | `bool` | `false` | no |
| <a name="input_endpoint_client_cidr_block"></a> [endpoint\_client\_cidr\_block](#input\_endpoint\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater. | `string` | `"10.100.100.0/22"` | no |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | VPN endpoint name | `string` | n/a | yes |
| <a name="input_endpoint_subnets"></a> [endpoint\_subnets](#input\_endpoint\_subnets) | List of IDs of endpoint subnets for network association | `list(string)` | n/a | yes |
| <a name="input_main_vpc_id"></a> [main\_vpc\_id](#input\_main\_vpc\_id) | CIDR ip range. | `string` | n/a | yes |
| <a name="input_peering_region"></a> [peering\_region](#input\_peering\_region) | CIDR ip range. | `string` | `"eu-central-1"` | no |
| <a name="input_peering_tags"></a> [peering\_tags](#input\_peering\_tags) | Tags: map | `map(string)` | `{}` | no |
| <a name="input_peering_vpc_id"></a> [peering\_vpc\_id](#input\_peering\_vpc\_id) | CIDR ip range. | `string` | n/a | yes |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | n/a | `map` | `{}` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnets of VPC. | `list(string)` | n/a | yes |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | n/a | `map` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnets of VPC. | `list(string)` | n/a | yes |
| <a name="input_saml_provider_arn"></a> [saml\_provider\_arn](#input\_saml\_provider\_arn) | The ARN of the IAM SAML identity provider. | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Whether or not to enable single NAT Gateway. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | CIDR ip range. | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->