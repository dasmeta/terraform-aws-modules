# Terraform AWS Client VPN Endpoint 

## How to create Application for VPN in AWS Single Sign-On
- Create private certificate in AWS Certificate Manager. Copy arn and use in module
- Open AWS SSO service page. Select Applications from the sidebar
- Choose Add a new application
- Select Add a custom SAML 2.0 application
- Fill Display name and Description
- Set session duration (VPN session duration) - 12h
- Select "If you don't have a metadata file, you can manually type your metadata values."
- Application ACS URL: http://127.0.0.1:35001
- Application SAML audience: urn:amazon:webservices:clientvpn
- Save changes
- Download AWS SSO SAML metadata file.
- Select tab "Attribute mappings":
    - Subject -> ${user:subject} -> emailAddress
    - NameID -> ${user:email} -> basic
    - FirstName -> ${user:name} -> basic
    - LastName -> ${user:familyName} -> basic
- Select tab "Assigned users", if you haven't user you should be create in SSO.
- Assign users or groups created on previous step
- You add AWS Account in AWS SSO, and add create Permission sets.
- Go to IAM Service -> "Identity Providers" and create "Add provider" choose configure provider "SAML", add provider name and upload SSO SAML metadata file.
- Copy saml arn and use in module.
- When module completely create you can download aws client vpn. https://aws.amazon.com/vpn/client-vpn-download/
- Add vpn profile and add ovpn file.


## Example

module network {
    source      = "dasmeta/modules/aws//modules/aws-vpn-vpnendpoint"
    
    # VPN Endpoint
    region                        = "us-east-1"
    enable_saml                   = false
    
    # If you connect many vpc in vpn you should create vpc peering
    create_peering                = true
    peering_vpc_ids               = ["vpc-0bdf97ed6f2d42f37","vpc-063637d7c4597b4cf"]

    # VPN vpc Id
    vpc_id                        = "vpc-041abee1cf26e79dc"
    endpoint_name                 = "module_vpn"
    endpoint_client_cidr_block    = "30.0.0.0/16"
    saml_provider_arn             = "" # SAML Provider ARN
    certificate_arn               = "" # Certificate ARN
    authorization_ingress         = ["10.0.0.0/16","20.0.0.0/16","40.0.0.0/16"] # VPCs CIDRs
    
    endpoint_subnets              = ["subnet-073672353a64692db0148"]
    
    # Add routes in VPN route table 
    additional_routes             = {
                                        first = {
                                                    cidr      = "20.0.0.0/16"
                                                    subnet_id = "subnet-073672353a64692db014"
                                                }
                                        second = {
                                                    cidr      = "40.0.0.0/16"
                                                    subnet_id = "subnet-073672353a64692db014"
                                                }
                                    }
    # Vpn file location and name file extension .ovpn
    vpn_file_download        = "/Users/devops/Documents/vpn.ovpn"
}

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_multi_peering"></a> [vpc\_multi\_peering](#module\_vpc\_multi\_peering) | ../aws_multi_vpc_peering/ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ec2_client_vpn_authorization_rule.my-vpn_sso_to_dns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_authorization_rule) | resource |
| [aws_ec2_client_vpn_endpoint.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_endpoint) | resource |
| [aws_ec2_client_vpn_network_association.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_network_association) | resource |
| [aws_ec2_client_vpn_route.my-vpn_sso](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_client_vpn_route) | resource |
| [aws_security_group.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [null_resource.client_vpn_download](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_vpc.my-vpn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_routes"></a> [additional\_routes](#input\_additional\_routes) | A map where the key is a subnet ID of endpoint subnet for network association and value is a cidr to where traffic should be routed from that subnet. Useful in cases if you need to route beyond the VPC subnet, for instance peered VPC | `any` | `{}` | no |
| <a name="input_authorization_ingress"></a> [authorization\_ingress](#input\_authorization\_ingress) | Add authorization rules to grant clients access to the networks. | `list(string)` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate arn | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_name_prefix"></a> [cloudwatch\_log\_group\_name\_prefix](#input\_cloudwatch\_log\_group\_name\_prefix) | Specifies the name prefix of CloudWatch Log Group for VPC flow logs. | `string` | `"/aws/client-vpn-endpoint/"` | no |
| <a name="input_cloudwatch_log_group_retention_in_days"></a> [cloudwatch\_log\_group\_retention\_in\_days](#input\_cloudwatch\_log\_group\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group for VPN connection logs. | `number` | `30` | no |
| <a name="input_create_peering"></a> [create\_peering](#input\_create\_peering) | Can create peering true : false | `bool` | `false` | no |
| <a name="input_enable_saml"></a> [enable\_saml](#input\_enable\_saml) | Whether or not to enable SAML Provider. | `bool` | `false` | no |
| <a name="input_endpoint_client_cidr_block"></a> [endpoint\_client\_cidr\_block](#input\_endpoint\_client\_cidr\_block) | The IPv4 address range, in CIDR notation, from which to assign client IP addresses. The address range cannot overlap with the local CIDR of the VPC in which the associated subnet is located, or the routes that you add manually. The address range cannot be changed after the Client VPN endpoint has been created. The CIDR block should be /22 or greater. | `string` | `"10.100.100.0/22"` | no |
| <a name="input_endpoint_name"></a> [endpoint\_name](#input\_endpoint\_name) | Name to be used on the Client VPN Endpoint | `string` | n/a | yes |
| <a name="input_endpoint_subnets"></a> [endpoint\_subnets](#input\_endpoint\_subnets) | List of IDs of endpoint subnets for network association | `list(string)` | n/a | yes |
| <a name="input_peering_vpc_ids"></a> [peering\_vpc\_ids](#input\_peering\_vpc\_ids) | n/a | `list(string)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_saml_provider_arn"></a> [saml\_provider\_arn](#input\_saml\_provider\_arn) | The ARN of the IAM SAML identity provider. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_tls_validity_period_hours"></a> [tls\_validity\_period\_hours](#input\_tls\_validity\_period\_hours) | Specifies the number of hours after initial issuing that the certificate will become invalid. | `number` | `47400` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpn_file_download"></a> [vpn\_file\_download](#input\_vpn\_file\_download) | n/a | `string` | `""` | no |
| <a name="input_vpn_route_table_ids"></a> [vpn\_route\_table\_ids](#input\_vpn\_route\_table\_ids) | Route table IDs of the requestor | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->