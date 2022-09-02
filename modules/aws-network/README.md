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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name                                                                 | Source                        | Version |
| -------------------------------------------------------------------- | ----------------------------- | ------- |
| <a name="module_vpc"></a> [vpc](#module_vpc)                         | terraform-aws-modules/vpc/aws | 2.77.0  |
| <a name="module_vpc-peering"></a> [vpc-peering](#module_vpc-peering) | ../aws-vpc-peering            | n/a     |
| <a name="module_vpn"></a> [vpn](#module_vpn)                         | ../aws-vpn-vpnendpoint        | n/a     |

## Resources

No resources.

## Inputs

| Name                                                                                                            | Description                                                                                                                                                                                                                                                                                                                                                      | Type           | Default             | Required |
| --------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------- | :------: |
| <a name="input_authorization_ingress"></a> [authorization_ingress](#input_authorization_ingress)                | Add authorization rules to grant clients access to the networks.                                                                                                                                                                                                                                                                                                 | `list(string)` | n/a                 |   yes    |
| <a name="input_availability_zones"></a> [availability_zones](#input_availability_zones)                         | List of VPC availability zones, e.g. ['eu-west-1a', 'eu-west-1b', 'eu-west-1c'].                                                                                                                                                                                                                                                                                 | `list(string)` | n/a                 |   yes    |
| <a name="input_certificate_arn"></a> [certificate_arn](#input_certificate_arn)                                  | Certificate arn                                                                                                                                                                                                                                                                                                                                                  | `string`       | n/a                 |   yes    |
| <a name="input_cidr"></a> [cidr](#input_cidr)                                                                   | CIDR ip range.                                                                                                                                                                                                                                                                                                                                                   | `string`       | n/a                 |   yes    |
| <a name="input_create_vpc"></a> [create_vpc](#input_create_vpc)                                                 | Whether or not to create a VPC.                                                                                                                                                                                                                                                                                                                                  | `bool`         | `true`              |    no    |
| <a name="input_create_vpc_peering"></a> [create_vpc_peering](#input_create_vpc_peering)                         | Whether or not to create a VPC Peering.                                                                                                                                                                                                                                                                                                                          | `bool`         | `false`             |    no    |
| <a name="input_enable_dns_hostnames"></a> [enable_dns_hostnames](#input_enable_dns_hostnames)                   | Whether or not to enable dns hostnames.                                                                                                                                                                                                                                                                                                                          | `bool`         | `true`              |    no    |
| <a name="input_enable_dns_support"></a> [enable_dns_support](#input_enable_dns_support)                         | Whether or not to enable dns support.                                                                                                                                                                                                                                                                                                                            | `bool`         | `true`              |    no    |
| <a name="input_enable_nat_gateway"></a> [enable_nat_gateway](#input_enable_nat_gateway)                         | Whether or not to enable NAT Gateway.                                                                                                                                                                                                                                                                                                                            | `bool`         | `true`              |    no    |
| <a name="input_enable_saml"></a> [enable_saml](#input_enable_saml)                                              | Whether or not to enable SAML Provider.                                                                                                                                                                                                                                                                                                                          | `bool`         | `false`             |    no    |
| <a name="input_endpoint_client_cidr_block"></a> [endpoint_client_cidr_block](#input_endpoint_client_cidr_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater. | `string`       | `"10.100.100.0/22"` |    no    |
| <a name="input_endpoint_name"></a> [endpoint_name](#input_endpoint_name)                                        | VPN endpoint name                                                                                                                                                                                                                                                                                                                                                | `string`       | n/a                 |   yes    |
| <a name="input_endpoint_subnets"></a> [endpoint_subnets](#input_endpoint_subnets)                               | List of IDs of endpoint subnets for network association                                                                                                                                                                                                                                                                                                          | `list(string)` | n/a                 |   yes    |
| <a name="input_main_vpc_id"></a> [main_vpc_id](#input_main_vpc_id)                                              | CIDR ip range.                                                                                                                                                                                                                                                                                                                                                   | `string`       | n/a                 |   yes    |
| <a name="input_peering_region"></a> [peering_region](#input_peering_region)                                     | CIDR ip range.                                                                                                                                                                                                                                                                                                                                                   | `string`       | `"eu-central-1"`    |    no    |
| <a name="input_peering_tags"></a> [peering_tags](#input_peering_tags)                                           | Tags: map                                                                                                                                                                                                                                                                                                                                                        | `map(string)`  | `{}`                |    no    |
| <a name="input_peering_vpc_id"></a> [peering_vpc_id](#input_peering_vpc_id)                                     | CIDR ip range.                                                                                                                                                                                                                                                                                                                                                   | `string`       | n/a                 |   yes    |
| <a name="input_private_subnet_tags"></a> [private_subnet_tags](#input_private_subnet_tags)                      | n/a                                                                                                                                                                                                                                                                                                                                                              | `map(any)`     | `{}`                |    no    |
| <a name="input_private_subnets"></a> [private_subnets](#input_private_subnets)                                  | Private subnets of VPC.                                                                                                                                                                                                                                                                                                                                          | `list(string)` | n/a                 |   yes    |
| <a name="input_public_subnet_tags"></a> [public_subnet_tags](#input_public_subnet_tags)                         | n/a                                                                                                                                                                                                                                                                                                                                                              | `map(any)`     | `{}`                |    no    |
| <a name="input_public_subnets"></a> [public_subnets](#input_public_subnets)                                     | Public subnets of VPC.                                                                                                                                                                                                                                                                                                                                           | `list(string)` | n/a                 |   yes    |
| <a name="input_saml_provider_arn"></a> [saml_provider_arn](#input_saml_provider_arn)                            | The ARN of the IAM SAML identity provider.                                                                                                                                                                                                                                                                                                                       | `string`       | n/a                 |   yes    |
| <a name="input_single_nat_gateway"></a> [single_nat_gateway](#input_single_nat_gateway)                         | Whether or not to enable single NAT Gateway.                                                                                                                                                                                                                                                                                                                     | `bool`         | `true`              |    no    |
| <a name="input_vpc_id"></a> [vpc_id](#input_vpc_id)                                                             | CIDR ip range.                                                                                                                                                                                                                                                                                                                                                   | `string`       | n/a                 |   yes    |
| <a name="input_vpc_name"></a> [vpc_name](#input_vpc_name)                                                       | VPC name.                                                                                                                                                                                                                                                                                                                                                        | `string`       | n/a                 |   yes    |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
